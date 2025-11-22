import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rental_booking_app/models/vehicle_model.dart';
import 'package:rental_booking_app/utils/logger.dart';
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

  List<VehicleModel> _vehicleModels = [];
  bool _modelLoading = false;
  String? _modelError;

  List<VehicleModel> get vehicleModels => _vehicleModels;
  bool get modelLoading => _modelLoading;
  String? get modelError => _modelError;

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

  Future<List<VehicleModel>> fetchModels(String typeId) async {
    try {
      final response = await _dio.get(AppEndpoints.vehicles(typeId));

      if (response.statusCode == 200) {
        final json = response.data['data'];
        return [VehicleModel.fromJson(json)];
      }
    } catch (e) {
      Logger.error("Model fetch error: $e");
    }
    return [];
  }

  Future<void> fetchVehicleModels(List<dynamic> models) async {
    _modelLoading = true;
    _vehicleModels = [];
    _modelError = null;
    notifyListeners();

    try {
      for (var model in models) {
        final response = await _dio.get(AppEndpoints.vehicles(model.id));
        if (response.statusCode == 200) {
          _vehicleModels.add(VehicleModel.fromJson(response.data['data']));
        }
      }
    } catch (e) {
      _modelError = "Failed to load vehicle models";
    }

    _modelLoading = false;
    notifyListeners();
  }
}
