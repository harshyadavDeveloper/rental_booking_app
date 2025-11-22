import 'package:flutter/material.dart';
import 'package:rental_booking_app/models/vehicle_type_model.dart';
import 'package:rental_booking_app/pages/date_range_screen.dart';

class VehicleModelScreen extends StatefulWidget {
  final VehicleTypeModel vehicleType;

  const VehicleModelScreen({super.key, required this.vehicleType});

  @override
  State<VehicleModelScreen> createState() => _VehicleModelScreenState();
}

class _VehicleModelScreenState extends State<VehicleModelScreen> {
  String? selectedModel;

  // Temporary hardcoded list of models
  final List<Map<String, String>> models = [
    {
      "name": "Swift",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/7/7c/2018_Maruti_Suzuki_Swift_front_view.jpg",
    },
    {
      "name": "R15",
      "image":
          "https://www.yamaha-motor-india.com/theme/v3/image/mediacenter/R15.png",
    },
    {
      "name": "Ashok Leyland Truck",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/9/9d/Ashok_Leyland_Truck.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Model"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose the specific model",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.separated(
                itemCount: models.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final model = models[index];
                  final bool isSelected = selectedModel == model["name"];

                  return InkWell(
                    onTap: () => setState(() {
                      selectedModel = model["name"];
                    }),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        color: isSelected
                            ? Colors.blue.withOpacity(0.08)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              model["image"]!,
                              height: 60,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_not_supported,
                                size: 50,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              model["name"]!,
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

      // Bottom CTA
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: selectedModel == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DateRangeScreen()),
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
