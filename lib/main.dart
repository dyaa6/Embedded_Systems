// main.dart
import 'package:flutter/material.dart';
import 'screens/about_page.dart';
import 'screens/home_page.dart';
import 'screens/graphs_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Data App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainTabs(),
    );
  }
}

class MainTabs extends StatefulWidget {
  @override
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    HomePage(),
    GraphsPage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), label: 'Graphs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.info_outline), label: 'About'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
