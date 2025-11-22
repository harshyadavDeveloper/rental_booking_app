import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_booking_app/controllers/booking_controller.dart';
import 'package:rental_booking_app/controllers/vehicle_controller.dart';
import 'package:rental_booking_app/pages/name_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VehicleController()),
        ChangeNotifierProvider(create: (_) => BookingController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',

        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const NameScreen(),
      ),
    );
  }
}
