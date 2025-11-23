import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/controllers/vehicle_controller.dart';
import 'package:rental_booking_app/controllers/booking_progress_provider.dart';
import 'package:rental_booking_app/utils/logger.dart';
import 'package:rental_booking_app/widgets/primary_button.dart';
import 'vehicle_model_screen.dart';

class VehicleTypeScreen extends StatefulWidget {
  final int wheels;
  const VehicleTypeScreen({super.key, required this.wheels});

  @override
  State<VehicleTypeScreen> createState() => _VehicleTypeScreenState();
}

class _VehicleTypeScreenState extends State<VehicleTypeScreen> {
  String? selectedTypeId;

  @override
  Widget build(BuildContext context) {
    final vehicleController = Provider.of<VehicleController>(context);

    /// Filter based on selected wheels
    final filteredTypes = vehicleController.vehicleTypes
        .where((e) => e.wheels == widget.wheels)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Vehicle Type")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: vehicleController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vehicleController.error != null
            ? Center(child: Text(vehicleController.error!))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select vehicle type",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),

                  ...filteredTypes.map((type) {
                    final isSelected = selectedTypeId == type.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: InkWell(
                        onTap: () {
                          setState(() => selectedTypeId = type.id);

                          Logger.info("Clicked Vehicle Type: ${type.name}");

                          /// Save to SQLite using Provider
                          Provider.of<BookingProgressProvider>(
                            context,
                            listen: false,
                          ).updateVehicleType(type.id, type.name);

                          Logger.success(
                            "Saved Vehicle Type to SQLite: ${type.id}",
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                            color: isSelected
                                ? Colors.blue.withValues(alpha: 0.07)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Text(
                                type.name,
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

                  // const Spacer(),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: PrimaryButton(
                      text: "Next",
                      disabled: selectedTypeId == null,
                      onPressed: () {
                        final selectedType = filteredTypes.firstWhere(
                          (e) => e.id == selectedTypeId,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                VehicleModelScreen(vehicleType: selectedType),
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
