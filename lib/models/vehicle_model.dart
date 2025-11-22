class VehicleModel {
  final String id;
  final String name;
  final String vehicleTypeId;
  final String? imageUrl;

  VehicleModel({
    required this.id,
    required this.name,
    required this.vehicleTypeId,
    this.imageUrl,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      vehicleTypeId: json['vehicleTypeId'] ?? '',
      imageUrl: json['image']?['publicURL'],
    );
  }
}
