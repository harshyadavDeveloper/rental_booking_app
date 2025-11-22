import 'vehicle_type_model.dart';

class VehicleTypeResponse {
  final List<VehicleTypeModel> data;
  final String? message;
  final int status;

  VehicleTypeResponse({required this.data, required this.status, this.message});

  factory VehicleTypeResponse.fromJson(Map<String, dynamic> json) {
    return VehicleTypeResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => VehicleTypeModel.fromJson(item))
          .toList(),
      status: json['status'] ?? 0,
      message: json['message'],
    );
  }
}
