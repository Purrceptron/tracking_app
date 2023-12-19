import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ตั้งค่า',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'BaiJamjuree',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
