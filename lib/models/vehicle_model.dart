class VehicleModel {
  final String id;
  final String name;
  final String vehicleTypeId;

  VehicleModel({
    required this.id,
    required this.name,
    required this.vehicleTypeId,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      vehicleTypeId: json['vehicleTypeId'] ?? '',
    );
  }
}
