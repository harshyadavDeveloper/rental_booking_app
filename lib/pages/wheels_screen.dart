import 'package:flutter/material.dart';

class WheelsScreen extends StatefulWidget {
  const WheelsScreen({super.key});

  @override
  State<WheelsScreen> createState() => _WheelsScreenState();
}

class _WheelsScreenState extends State<WheelsScreen> {
  int? selectedWheels;

  final List<int> wheelsOptions = [2, 3, 4, 6]; // temporary static UI data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Number of Wheels"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select number of wheels",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            Expanded(
              child: ListView.separated(
                itemCount: wheelsOptions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final number = wheelsOptions[index];
                  final isSelected = selectedWheels == number;

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() => selectedWheels = number);
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
                            ? Colors.blue.withOpacity(0.08)
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => const VehicleTypeScreen()),
                  // );
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
