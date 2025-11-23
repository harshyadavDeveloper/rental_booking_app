class BookingProgressModel {
  int? id;
  String? firstName;
  String? lastName;
  int? wheels;
  String? vehicleTypeId;
  String? vehicleTypeName;
  String? modelId;
  String? modelName;
  String? modelImageUrl;
  String? startDate;
  String? endDate;

  BookingProgressModel({
    this.id,
    this.firstName,
    this.lastName,
    this.wheels,
    this.vehicleTypeId,
    this.vehicleTypeName,
    this.modelId,
    this.modelName,
    this.modelImageUrl,
    this.startDate,
    this.endDate,
  });

  // Convert Model → Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "wheels": wheels,
      "vehicleTypeId": vehicleTypeId,
      "vehicleTypeName": vehicleTypeName,
      "modelId": modelId,
      "modelName": modelName,
      "startDate": startDate,
      "endDate": endDate,
    };
  }

  // Convert SQLite → Model
  factory BookingProgressModel.fromMap(Map<String, dynamic> map) {
    return BookingProgressModel(
      id: map["id"],
      firstName: map["firstName"],
      lastName: map["lastName"],
      wheels: map["wheels"],
      vehicleTypeId: map["vehicleTypeId"],
      vehicleTypeName: map["vehicleTypeName"],
      modelId: map["modelId"],
      modelName: map["modelName"],
      modelImageUrl: map['modelImageUrl'],
      startDate: map["startDate"],
      endDate: map["endDate"],
    );
  }
}
