class AppEndpoints {
  AppEndpoints._();

  /// Base URL
  static const String baseUrl =
      "https://octalogic-test-frontend.vercel.app/api/v1";

  static const String wheels = "$baseUrl/vehicleTypes";

  static String vehicles(String typeId) => "$baseUrl/vehicles/$typeId";

  /// Booking
  static String booking(String vehicleId) => "$baseUrl/bookings/$vehicleId";
}
