// screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/sensor_data.dart';
import '../services/firebase_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<SensorData>> _futureSensors;
  // Counter used to force rebuild ExpansionTiles with new keys
  int _expansionTileResetCounter = 0;

  @override
  void initState() {
    super.initState();
    _futureSensors = fetchSensorData();
  }

  // Group sensor data by day (formatted as "YYYY/MM/DD")
  Map<String, List<SensorData>> _groupByDay(List<SensorData> sensors) {
    Map<String, List<SensorData>> grouped = {};
    final formatter = DateFormat('yyyy/MM/dd');
    for (var sensor in sensors) {
      String day = formatter.format(sensor.timestamp);
      if (grouped.containsKey(day)) {
        grouped[day]!.add(sensor);
      } else {
        grouped[day] = [sensor];
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Data Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            tooltip: 'Close all cards',
            onPressed: () {
              setState(() {
                // Incrementing the counter will change the key of each ExpansionTile
                // causing them to rebuild in the collapsed state.
                _expansionTileResetCounter++;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SensorData>>(
        future: _futureSensors,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var groupedData = _groupByDay(snapshot.data ?? []);
            return ListView(
              children: groupedData.entries.map((entry) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ExpansionTile(
                    // Using a unique key that changes when _expansionTileResetCounter updates.
                    key: Key('${entry.key}_$_expansionTileResetCounter'),
                    title: Text(entry.key),
                    // Always build the tile in collapsed mode.
                    initiallyExpanded: false,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Index')),
                            DataColumn(label: Text('Temp')),
                            DataColumn(label: Text('Hum')),
                            DataColumn(label: Text('Light')),
                            DataColumn(label: Text('Date & Time')),
                          ],
                          rows: List.generate(entry.value.length, (index) {
                            final sensor = entry.value[index];
                            final formattedDateTime =
                                DateFormat('MM/dd hh:mm:ss a')
                                    .format(sensor.timestamp);
                            return DataRow(cells: [
                              DataCell(Text('${index + 1}')),
                              DataCell(Text('${sensor.temperature} °C')),
                              DataCell(Text('${sensor.humidity} %')),
                              DataCell(Text('${sensor.ldr}')),
                              DataCell(Text(formattedDateTime)),
                            ]);
                          }),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
