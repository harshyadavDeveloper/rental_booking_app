import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/controllers/booking_progress_provider.dart';
import 'package:rental_booking_app/utils/constants.dart';
import 'package:rental_booking_app/utils/logger.dart';
import 'package:rental_booking_app/widgets/primary_button.dart';
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
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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

              buildTextField(
                controller: _firstNameController,
                label: "First Name",
                error: "Enter a valid first name",
              ),

              const SizedBox(height: 15),

              buildTextField(
                controller: _lastNameController,
                label: "Last Name",
                error: "Enter a valid last name",
              ),

              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(10),
                child: PrimaryButton(
                  text: "Next",
                  // disabled: !_formKey.currentState!.validate(),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _saveNameToDB();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WheelsScreen()),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
