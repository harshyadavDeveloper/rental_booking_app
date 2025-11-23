import 'package:flutter/material.dart';
import 'package:rental_booking_app/utils/booking_progress_service.dart';
import '../models/booking_progress_model.dart';

class BookingProgressProvider extends ChangeNotifier {
  final BookingProgressService _service = BookingProgressService();
  BookingProgressModel progress = BookingProgressModel(id: 1);

  bool isLoading = false;

  Future<void> loadProgress() async {
    isLoading = true;
    notifyListeners();

    final saved = await _service.getProgress();
    if (saved != null) {
      progress = saved;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateField(String field, dynamic value) async {
    await _service.updateProgressField(field, value);
    await loadProgress();
  }

  // ---------- Individual UPDATES ----------
  Future<void> updateFirstName(String first) =>
      updateField("first_name", first);

  Future<void> updateLastName(String last) => updateField("last_name", last);

  Future<void> updateWheels(int wheels) => updateField("wheels", wheels);

  Future<void> updateVehicleType(String typeId, String typeName) async {
    await updateField("vehicleTypeId", typeId);
    await updateField("vehicleTypeName", typeName);
  }

  Future<void> updateVehicleModel(
    String modelId,
    String modelName,
    String imageUrl,
  ) async {
    await updateField("modelId", modelId);
    await updateField("modelName", modelName);
    await updateField("modelImageUrl", imageUrl);
  }

  Future<void> updateStartEndDates(DateTime start, DateTime end) async {
    await updateField("startDate", start.toIso8601String());
    await updateField("endDate", end.toIso8601String());
  }

  // 🔹 NEW: Compatibility method (because UI was calling updateDates)
  Future<void> updateDates(DateTime start, DateTime end) =>
      updateStartEndDates(start, end);

  // ---------- RESET ----------
  Future<void> resetProgress() async {
    await _service.clearProgress();
    progress = BookingProgressModel(id: 1);
    notifyListeners();
  }
}
