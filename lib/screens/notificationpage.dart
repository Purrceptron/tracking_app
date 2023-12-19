import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'การแจ้งเตือน',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'BaiJamjuree',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'ไม่มีการแจ้งเตือน',
          style: TextStyle(
            fontFamily: 'BaiJamjuree',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
