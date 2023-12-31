import 'package:flutter/material.dart';
import 'package:gps_tracking_app/screens/displaypage.dart';
import 'package:gps_tracking_app/screens/devicepage.dart';
import 'package:gps_tracking_app/screens/notificationpage.dart';
import 'package:gps_tracking_app/screens/settingpage.dart';
//import 'package:gps_tracking_app/screens/socketdemo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int currentIndex = 0;
  final screens = [
    const DisplayPage(),
    const DevicePage(),
    const NotificationPage(),
    const SettingPage(),
    //const SocketDemo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(
            fontFamily: 'BaiJamjuree', fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
            fontFamily: 'BaiJamjuree', fontWeight: FontWeight.w500),
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'แสดงผล',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'อุปกรณ์',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'การแจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'ตั้งค่า',
          ),
        ],
      ),
    );
  }
}
