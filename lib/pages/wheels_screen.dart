import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/controllers/vehicle_controller.dart';
import 'package:rental_booking_app/pages/vehicle_type_screen.dart';

class WheelsScreen extends StatefulWidget {
  const WheelsScreen({super.key});

  @override
  State<WheelsScreen> createState() => _WheelsScreenState();
}

class _WheelsScreenState extends State<WheelsScreen> {
  int? selectedWheels;

  final List<int> wheelsOptions = [2, 3, 4, 6]; // temporary static UI data

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

                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.vehicleTypes.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = controller.vehicleTypes[index];
                        final number = item.wheels;
                        final isSelected = selectedWheels == number;

                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() => selectedWheels = number);
                            print('selected wheels: $selectedWheels');
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
          onPressed: selectedWheels == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          VehicleTypeScreen(wheels: selectedWheels!),
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
