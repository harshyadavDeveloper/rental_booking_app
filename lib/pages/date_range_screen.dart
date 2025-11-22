import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/utils/logger.dart';
import '../controllers/booking_controller.dart';

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

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  Future<void> pickDateRange() async {
    final controller = Provider.of<BookingController>(context, listen: false);

    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),

      // disable blocked dates
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
                        color: Colors.red.withValues(alpha: 0.08),
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

                  // Selected range box
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

                  // Pick date range button
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
              : () {
                  // later: navigate to summary / POST booking
                  Logger.info("Selected range: $selectedRange");
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
