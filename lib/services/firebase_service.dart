// services/firebase_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/sensor_data.dart';

const String firebaseUrl =
    "https://epower-44f2e-default-rtdb.asia-southeast1.firebasedatabase.app/sensors.json";
const String dbSecret = "G7FMO4LjkSOHrs5Ms5it3m1aHKKfOsb57Z9SzP2e";

Future<List<SensorData>> fetchSensorData() async {
  final response = await http.get(Uri.parse("$firebaseUrl?auth=$dbSecret"));
  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    List<SensorData> sensorList = [];
    data.forEach((key, value) {
      sensorList.add(SensorData.fromJson(value));
    });
    return sensorList;
  } else {
    throw Exception("Failed to load sensor data");
  }
}
