import 'package:rental_booking_app/models/vehicle_model.dart';

class VehicleTypeModel {
  final String id;
  final String name;
  final int wheels;
  final String type;
  final List<VehicleModel> vehicles;

  VehicleTypeModel({
    required this.id,
    required this.name,
    required this.wheels,
    required this.type,
    required this.vehicles,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      wheels: json['wheels'] ?? 0,
      type: json['type'] ?? '',
      vehicles: (json['vehicles'] as List<dynamic>? ?? [])
          .map((item) => VehicleModel.fromJson(item))
          .toList(),
    );
  }
}
