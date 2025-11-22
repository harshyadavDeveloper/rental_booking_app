import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rental_booking_app/utils/urls.dart';
import '../models/vehicle_type_model.dart';

class VehicleController extends ChangeNotifier {
  final Dio _dio = Dio();

  bool _isLoading = false;
  String? _error;
  List<VehicleTypeModel> _vehicleTypes = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<VehicleTypeModel> get vehicleTypes => _vehicleTypes;

  Future<void> fetchVehicleTypes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    const url = AppEndpoints.wheels;

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          _vehicleTypes = (response.data['data'] as List)
              .map((json) => VehicleTypeModel.fromJson(json))
              .toList();
        } else {
          _error = "No data found";
        }
      } else {
        _error = "Something went wrong";
      }
    } catch (e) {
      _error = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}
