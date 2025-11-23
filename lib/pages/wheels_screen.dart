import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/controllers/vehicle_controller.dart';
import 'package:rental_booking_app/controllers/booking_progress_provider.dart';
import 'package:rental_booking_app/pages/vehicle_type_screen.dart';
import 'package:rental_booking_app/utils/logger.dart';
import 'package:rental_booking_app/widgets/primary_button.dart';

class WheelsScreen extends StatefulWidget {
  const WheelsScreen({super.key});

  @override
  State<WheelsScreen> createState() => _WheelsScreenState();
}

class _WheelsScreenState extends State<WheelsScreen> {
  int? selectedWheels;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getWheels();
    });
  }

  Future<void> getWheels() async {
    final controller = Provider.of<VehicleController>(context, listen: false);
    controller.fetchVehicleTypes();
  }

  Future<void> _saveWheels() async {
    final progress = Provider.of<BookingProgressProvider>(
      context,
      listen: false,
    );
    await progress.updateWheels(selectedWheels!);
    Logger.success("Wheels saved to DB: $selectedWheels");
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VehicleController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Number of Wheels")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.error != null
            ? Center(child: Text(controller.error!))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select number of wheels",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  // List of items (not expanded)
                  ...controller.vehicleTypes.map((item) {
                    final number = item.wheels;
                    final isSelected = selectedWheels == number;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() => selectedWheels = number);
                          Logger.info("Selected wheels: $selectedWheels");
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blueAccent
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? Colors.blue.withValues(alpha: 0.08)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "$number Wheels",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: isSelected ? Colors.blue : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  // const Spacer(), // This pushes button to bottom but not screen bottom
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: PrimaryButton(
                      text: "Next",
                      disabled: selectedWheels == null,
                      onPressed: () async {
                        await _saveWheels();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                VehicleTypeScreen(wheels: selectedWheels!),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
