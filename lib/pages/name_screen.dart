import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/controllers/booking_progress_provider.dart';
import 'package:rental_booking_app/utils/logger.dart';
import 'wheels_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load saved progress
    Future.microtask(() async {
      final progress = Provider.of<BookingProgressProvider>(
        context,
        listen: false,
      ).progress;
      _firstNameController.text = progress.firstName ?? "";
      _lastNameController.text = progress.lastName ?? "";
    });
  }

  Future<void> _saveNameToDB() async {
    final provider = Provider.of<BookingProgressProvider>(
      context,
      listen: false,
    );

    await provider.updateField("firstName", _firstNameController.text.trim());
    await provider.updateField("lastName", _lastNameController.text.trim());

    Logger.info(
      "📌 Saved to DB → First Name: ${_firstNameController.text}, Last Name: ${_lastNameController.text}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Rental Booking"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What's your name?",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              _buildTextField(
                controller: _firstNameController,
                label: "First Name",
                error: "Enter a valid first name",
              ),

              const SizedBox(height: 15),

              _buildTextField(
                controller: _lastNameController,
                label: "Last Name",
                error: "Enter a valid last name",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await _saveNameToDB();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WheelsScreen()),
              );
            }
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String error,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v == null || v.trim().length < 2 ? error : null,
    );
  }
}
