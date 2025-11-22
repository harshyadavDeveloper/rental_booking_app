import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../utils/urls.dart';

class BookingController extends ChangeNotifier {
  final Dio _dio = Dio();

  Set<DateTime> blockedDates = {};

  List<BookingModel> bookings = [];

  bool loadingDates = false;
  String? dateError;

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  Future<void> fetchUnavailableDates(String modelId) async {
    loadingDates = true;
    dateError = null;
    blockedDates = {};
    bookings = [];
    notifyListeners();

    try {
      final response = await _dio.get(AppEndpoints.booking(modelId));

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];

        final parsedBookings = data
            .map((e) => BookingModel.fromJson(e))
            .toList();

        bookings = parsedBookings;

        final Set<DateTime> datesToBlock = {};

        for (var booking in parsedBookings) {
          DateTime day = _normalizeDate(booking.startDate);
          final DateTime end = _normalizeDate(booking.endDate);

          while (!day.isAfter(end)) {
            datesToBlock.add(day);
            day = day.add(const Duration(days: 1));
          }
        }

        blockedDates = datesToBlock;
      }
    } on DioException catch (e) {
      dateError = "Failed to load unavailable dates: ${e.message}";
    } catch (e) {
      dateError = "An unexpected error occurred: $e";
    }

    loadingDates = false;
    notifyListeners();
  }
}
