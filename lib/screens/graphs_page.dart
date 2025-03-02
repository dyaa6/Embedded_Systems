// graphs_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../model/sensor_data.dart';
import '../services/firebase_service.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({Key? key}) : super(key: key);

  @override
  _GraphsPageState createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  late Future<List<SensorData>> _futureSensors;
  bool isLineChart = true; // Toggle between line and bar charts
  String sensorType = "Temperature"; // Default sensor type to display
  final List<String> sensorTypes = ["Temperature", "Humidity", "Light"];
  String?
      selectedDay; // New: currently selected day (formatted as "yyyy-MM-dd")

  @override
  void initState() {
    super.initState();
    _futureSensors = fetchSensorData();
  }

  // Helper function to get sensor value based on selected type.
  double getSensorValue(SensorData sensor) {
    switch (sensorType) {
      case "Temperature":
        return sensor.temperature;
      case "Humidity":
        return sensor.humidity.toDouble();
      case "Light":
        return sensor.ldr.toDouble();
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphs'),
        actions: [
          IconButton(
            icon: Icon(isLineChart ? Icons.show_chart : Icons.bar_chart),
            tooltip:
                isLineChart ? 'Switch to Bar Chart' : 'Switch to Line Chart',
            onPressed: () {
              setState(() {
                isLineChart = !isLineChart;
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<SensorData>>(
        future: _futureSensors,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final sensorData = snapshot.data!;
            // Sort sensor data by timestamp for proper time series order.
            sensorData.sort((a, b) => a.timestamp.compareTo(b.timestamp));

            // Extract the unique days that have data.
            Set<String> uniqueDaysSet = sensorData
                .map((data) => DateFormat('yyyy-MM-dd').format(data.timestamp))
                .toSet();
            List<String> uniqueDays = uniqueDaysSet.toList()..sort();

            // Set the selected day if not yet set or if it is no longer valid.
            if (selectedDay == null || !uniqueDays.contains(selectedDay)) {
              selectedDay = uniqueDays.isNotEmpty ? uniqueDays.first : null;
            }

            // Filter sensor data for the selected day.
            List<SensorData> filteredData = sensorData.where((data) {
              return DateFormat('yyyy-MM-dd').format(data.timestamp) ==
                  selectedDay;
            }).toList();

            // Downsampling: if there are too many points, sample a subset.
            const int maxPoints = 100;
            List<SensorData> displayData;
            if (filteredData.length > maxPoints) {
              int step = (filteredData.length / maxPoints).ceil();
              displayData = [
                for (int i = 0; i < filteredData.length; i += step)
                  filteredData[i]
              ];
            } else {
              displayData = filteredData;
            }

            // Prepare a list of FlSpot points using the index as the x-axis.
            List<FlSpot> spots = [];
            for (int i = 0; i < displayData.length; i++) {
              spots.add(FlSpot(i.toDouble(), getSensorValue(displayData[i])));
            }

            // Function to format timestamps on the x-axis.
            Widget getTimeLabel(double value, TitleMeta meta) {
              int index = value.toInt();
              if (index < 0 || index >= displayData.length) return Container();
              String formattedTime =
                  DateFormat('HH:mm').format(displayData[index].timestamp);
              return Text(formattedTime, style: const TextStyle(fontSize: 10));
            }

            // Function to display sensor value with unit on the y-axis.
            Widget getUnitLabel(double value, TitleMeta meta) {
              String unit;
              switch (sensorType) {
                case "Temperature":
                  unit = "°C";
                  break;
                case "Humidity":
                  unit = "%";
                  break;
                case "Light":
                  unit = "lux";
                  break;
                default:
                  unit = "";
              }
              return Text("${value.toStringAsFixed(1)} $unit",
                  style: const TextStyle(fontSize: 10));
            }

            // Dropdown for sensor type selection.
            Widget sensorTypeDropdown = Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: sensorType,
                onChanged: (String? newValue) {
                  setState(() {
                    sensorType = newValue!;
                  });
                },
                items:
                    sensorTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            );

            // Dropdown for day selection.
            Widget dayDropdown = Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: selectedDay,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDay = newValue;
                  });
                },
                items: uniqueDays.map<DropdownMenuItem<String>>((String day) {
                  // Format the day for display (e.g., "Mar 03, 2025").
                  String displayDay =
                      DateFormat('MMM dd, yyyy').format(DateTime.parse(day));
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(displayDay),
                  );
                }).toList(),
              ),
            );

            // Build chart widget based on the selected chart type.
            Widget chartWidget;
            if (isLineChart) {
              chartWidget = LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      barWidth: 3,
                      color: Colors.blue,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: getTimeLabel,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: getTimeLabel,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: getUnitLabel,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              );
            } else {
              List<BarChartGroupData> barGroups =
                  List.generate(spots.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barsSpace: 4,
                  barRods: [
                    BarChartRodData(
                      toY: spots[i].y,
                      width: 12,
                      color: Colors.blue,
                    ),
                  ],
                );
              });

              chartWidget = BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: getTimeLabel,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: getTimeLabel,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: getUnitLabel,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black12),
                  ),
                  barTouchData: BarTouchData(enabled: true),
                ),
              );
            }

            return Column(
              children: [
                // Two drop-down menus: one for sensor type and one for day selection.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    sensorTypeDropdown,
                    dayDropdown,
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: chartWidget,
                  ),
                ),
              ],
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
