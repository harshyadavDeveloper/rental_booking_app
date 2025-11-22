import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/controllers/vehicle_controller.dart';
import 'package:rental_booking_app/utils/logger.dart';
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
    final controller = Provider.of<VehicleController>(context);

    /// Filter data from API by selected wheels
    final filteredTypes = controller.vehicleTypes
        .where((e) => e.wheels == widget.wheels)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Vehicle Type"), elevation: 0),
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
                    "Select vehicle type",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),

                  Expanded(
                    child: ListView.separated(
                      itemCount: filteredTypes.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final type = filteredTypes[index];
                        final isSelected = selectedTypeId == type.id;

                        return InkWell(
                          onTap: () {
                            setState(() => selectedTypeId = type.id);
                          },
                          borderRadius: BorderRadius.circular(12),
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
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: selectedTypeId == null
              ? null
              : () {
                  final selectedType = filteredTypes.firstWhere(
                    (e) => e.id == selectedTypeId,
                  );
                  Logger.info("selected type ${selectedType.id}");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          VehicleModelScreen(vehicleType: selectedType),
                    ),
                  );
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
