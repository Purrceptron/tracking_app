// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({
    super.key,
    required this.list,
  });
  final Object list;

  @override
  Widget build(BuildContext context) {
    print(list);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียด',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'BaiJamjuree'),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Text(
        list.toString(),
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'BaiJamjuree'),
      ),
    );
  }
}
