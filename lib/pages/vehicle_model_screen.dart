import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/controllers/vehicle_controller.dart';
import '../models/vehicle_type_model.dart';
import 'date_range_screen.dart';

class VehicleModelScreen extends StatefulWidget {
  final VehicleTypeModel vehicleType;

  const VehicleModelScreen({super.key, required this.vehicleType});

  @override
  State<VehicleModelScreen> createState() => _VehicleModelScreenState();
}

class _VehicleModelScreenState extends State<VehicleModelScreen> {
  String? selectedModelId;

  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   Provider.of<VehicleController>(
    //     context,
    //     listen: false,
    //   ).fetchVehicleModels(widget.vehicleType.vehicles);
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getVehicleModels();
    });
  }

  Future<void> getVehicleModels() async {
    final controller = Provider.of<VehicleController>(context, listen: false);
    controller.fetchVehicleModels(widget.vehicleType.vehicles);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VehicleController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Select Model")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: controller.modelLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.modelError != null
            ? Center(child: Text(controller.modelError!))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose the specific model",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.vehicleModels.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final model = controller.vehicleModels[index];
                        final isSelected = selectedModelId == model.id;

                        return InkWell(
                          onTap: () =>
                              setState(() => selectedModelId = model.id),
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                              color: isSelected
                                  ? Colors.blue.withOpacity(0.08)
                                  : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    model.imageUrl ?? "",
                                    height: 60,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.drive_eta, size: 50),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    model.name,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
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
          onPressed: selectedModelId == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DateRangeScreen(
                        // modelId: selectedModelId!,
                      ),
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
