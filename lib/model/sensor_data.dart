// model/sensor_data.dart
class SensorData {
  final double temperature;
  final int humidity;
  final int ldr;
  final DateTime timestamp;

  SensorData(
      {required this.temperature,
      required this.humidity,
      required this.ldr,
      required this.timestamp});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: json['temperature']?.toDouble() ?? 0.0,
      humidity: json['humidity'] ?? 0,
      ldr: json['ldr'] ?? 0,
      // Parse the timestamp assuming the format "YYYY-MM-DD HH:MM:SS"
      timestamp: DateTime.tryParse(json['timestamp']) ?? DateTime.now(),
    );
  }
}
