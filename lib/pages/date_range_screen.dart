import 'package:flutter/material.dart';

class DateRangeScreen extends StatefulWidget {
  const DateRangeScreen({super.key});

  @override
  State<DateRangeScreen> createState() => _DateRangeScreenState();
}

class _DateRangeScreenState extends State<DateRangeScreen> {
  DateTimeRange? selectedRange;

  // Hardcoded unavailable dates
  final List<DateTime> blockedDates = [
    DateTime(2025, 11, 25),
    DateTime(2025, 11, 26),
    DateTime(2025, 11, 28),
  ];

  Future<void> pickDateRange() async {
    final now = DateTime.now();
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.blue, // header + selected dates
          ),
        ),
        child: child!,
      ),

      // ✅ Correct signature now
      selectableDayPredicate: (DateTime day, DateTime? start, DateTime? end) {
        for (final blocked in blockedDates) {
          if (day.year == blocked.year &&
              day.month == blocked.month &&
              day.day == blocked.day) {
            return false; // disable this date
          }
        }
        return true;
      },
    );

    if (result != null) {
      setState(() {
        selectedRange = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedText = selectedRange == null
        ? "No dates selected"
        : "${selectedRange!.start.day}/${selectedRange!.start.month}/${selectedRange!.start.year} → "
              "${selectedRange!.end.day}/${selectedRange!.end.month}/${selectedRange!.end.year}";

    return Scaffold(
      appBar: AppBar(title: const Text("Select Date Range"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose rental period",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// Display selected range box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
              child: Text(
                selectedText,
                style: TextStyle(
                  fontSize: 16,
                  color: selectedRange == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Open Picker Button
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

      /// Next button disabled until date selected
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: selectedRange == null
              ? null
              : () {
                  // TODO: Navigate to summary/submit screen
                },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Next"),
        ),
      ),
    );
  }
}
