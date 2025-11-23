import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/booking_progress_provider.dart';
import '../pages/name_screen.dart';

class BookingSummaryDialog extends StatelessWidget {
  final String title;

  const BookingSummaryDialog({super.key, this.title = "Booking Summary"});

  @override
  Widget build(BuildContext context) {
    final progress = Provider.of<BookingProgressProvider>(
      context,
      listen: false,
    ).progress;

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: ${progress.firstName} ${progress.lastName}"),
          Text("Wheels: ${progress.wheels}"),
          Text("Vehicle Type ID: ${progress.vehicleTypeId}"),
          Text("Model ID: ${progress.modelId}"),
          Text("Model Name: ${progress.modelName}"),

          if (progress.modelImageUrl != null &&
              progress.modelImageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  progress.modelImageUrl!,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          if (progress.startDate != null)
            Text("Start: ${_formatDate(progress.startDate!)}"),
          if (progress.endDate != null)
            Text("End: ${_formatDate(progress.endDate!)}"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final provider = Provider.of<BookingProgressProvider>(
              context,
              listen: false,
            );

            await provider.resetProgress();
            await provider.loadProgress();

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
    );
  }

  static String _formatDate(String iso) {
    final d = DateTime.parse(iso);
    return "${d.day}/${d.month}/${d.year}";
  }
}
