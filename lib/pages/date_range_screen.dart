import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/controllers/booking_controller.dart';
import 'package:rental_booking_app/controllers/booking_progress_provider.dart';
import 'package:rental_booking_app/pages/name_screen.dart';
import 'package:rental_booking_app/utils/logger.dart';

class DateRangeScreen extends StatefulWidget {
  final String modelId;

  const DateRangeScreen({super.key, required this.modelId});

  @override
  State<DateRangeScreen> createState() => _DateRangeScreenState();
}

class _DateRangeScreenState extends State<DateRangeScreen> {
  DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUnavailableDates();
    });
  }

  Future<void> fetchUnavailableDates() async {
    final controller = Provider.of<BookingController>(context, listen: false);
    await controller.fetchUnavailableDates(widget.modelId);
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  Future<void> pickDateRange() async {
    final controller = Provider.of<BookingController>(context, listen: false);

    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      selectableDayPredicate: (DateTime day, DateTime? start, DateTime? end) {
        final normalized = _normalizeDate(day);
        return !controller.blockedDates.contains(normalized);
      },
    );

    if (result != null) {
      bool hasBlocked = false;
      DateTime day = _normalizeDate(result.start);
      final DateTime end = _normalizeDate(result.end);

      while (!day.isAfter(end)) {
        if (controller.blockedDates.contains(day)) {
          hasBlocked = true;
          break;
        }
        day = day.add(const Duration(days: 1));
      }

      if (hasBlocked) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "The selected date range contains unavailable dates.",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        setState(() => selectedRange = result);
      }
    }
  }

  /// 🔹 Show Summary Dialog
  void showSummaryDialog(BuildContext context) {
    final progress = Provider.of<BookingProgressProvider>(
      context,
      listen: false,
    ).progress;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Booking Summary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${progress.firstName} ${progress.lastName}"),
            Text("Wheels: ${progress.wheels}"),
            Text("Vehicle Type ID: ${progress.vehicleTypeId}"),
            Text("Model ID: ${progress.modelId}"),
            // Text("Model Name: ${progress.modelName}"),
            // Text(
            //     "Start Date: ${progress.startDate?.day}/${progress.startDate?.month}/${progress.startDate?.year}"),
            // Text(
            //     "End Date: ${progress.endDate?.day}/${progress.endDate?.month}/${progress.endDate?.year}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<BookingProgressProvider>(
                context,
                listen: false,
              ).resetProgress();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const NameScreen()),
                (route) => false,
              );
            },
            child: const Text("Reset"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BookingController>(context);

    final String dateText = selectedRange == null
        ? "No dates selected"
        : "${selectedRange!.start.day}/${selectedRange!.start.month}/${selectedRange!.start.year} → "
              "${selectedRange!.end.day}/${selectedRange!.end.month}/${selectedRange!.end.year}";

    return Scaffold(
      appBar: AppBar(title: const Text("Select Date Range")),
      body: controller.loadingDates
          ? const Center(child: CircularProgressIndicator())
          : controller.dateError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  controller.dateError!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose rental period 📅",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  if (controller.bookings.isNotEmpty) ...[
                    const Text(
                      "Unavailable Dates:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.redAccent, width: 1.3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.bookings.map((booking) {
                          final s = booking.startDate;
                          final e = booking.endDate;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              "• ${s.day}/${s.month}/${s.year} → ${e.day}/${e.month}/${e.year}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                    ),
                    child: Text(
                      dateText,
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedRange == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: pickDateRange,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text("Pick Date Range"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                    ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: selectedRange == null
              ? null
              : () async {
                  Logger.info("Selected range: $selectedRange");

                  final progressProvider = Provider.of<BookingProgressProvider>(
                    context,
                    listen: false,
                  );

                  await progressProvider.updateStartEndDates(
                    selectedRange!.start,
                    selectedRange!.end,
                  );

                  if (mounted) showSummaryDialog(context);
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Confirm Booking"),
        ),
      ),
    );
  }
}
