// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const InfoPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print(data);

    //Default font
    const commonTextStyle = TextStyle(
      fontFamily: 'BaiJamjuree',
      fontSize: 13.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียด',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: 'BaiJamjuree',
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: const SizedBox(
              width: 72.0,
              height: 72.0,
              child: CircleAvatar(
                radius: 72.0,
                child: Icon(Icons.car_rental),
              ),
            ),
            title: Text(
              data['carId'],
              style: commonTextStyle,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('IMEI', style: commonTextStyle),
            trailing: Text(
              data['imei'],
              style: commonTextStyle,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('หมายเลขเครื่อง', style: commonTextStyle),
            trailing: Text(
              data['deviceId'].toString(),
              style: commonTextStyle,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('ป้ายทะเบียน', style: commonTextStyle),
            trailing: Text(
              data['carId'],
              style: commonTextStyle,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('สถานะ', style: commonTextStyle),
            trailing: Text(
              '${data['carStatus']} ${data['detail']}',
              style: commonTextStyle,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('เวลา', style: commonTextStyle),
            trailing: Text(
              data['timeStatus'],
              style: commonTextStyle,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('ความเร็ว', style: commonTextStyle),
            trailing: Text(
              data['speed'],
              style: commonTextStyle,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text(
              'ตำแหน่ง',
              style: TextStyle(fontSize: 13.0, fontFamily: 'BaiJamjuree'),
            ),
            trailing: Text(
              '${data['latitude']}, ${data['longitude']}',
              style: const TextStyle(fontSize: 13.0, fontFamily: 'BaiJamjuree'),
            ),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
