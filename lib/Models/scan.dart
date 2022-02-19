class Data {
  final String locationDisplay;
  final String recordedDatetime;
  final int temperatureLevel;
  final String temperatureMeasurement;
  final int humidityLevel;
  final String humidityMeasurement;
  final String recordedBy;
  Data({
    required this.locationDisplay,
    required this.recordedDatetime,
    required this.temperatureLevel,
    required this.temperatureMeasurement,
    required this.humidityLevel,
    required this.humidityMeasurement,
    required this.recordedBy,
  });
  factory Data.fromJson(Map<String, dynamic> json) { return Data(
    locationDisplay: json['locationDisplay'],
    recordedDatetime: json['recordedDatetime'],
    temperatureLevel: json['temperatureLevel'],
    temperatureMeasurement: json['temperatureMeasurement'],
    humidityLevel: json['humidityLevel'],
    humidityMeasurement: json['humidityMeasurement'],
    recordedBy: json['recordedBy'],
  );
  }
}