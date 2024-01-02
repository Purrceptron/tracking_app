// ignore_for_file: avoid_print
import 'package:flutter/material.dart';

class OtherPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const OtherPage({super.key, required this.data});

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
        title: Text(
          data['carId'],
          style: const TextStyle(
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
            title: const Text('IMEI', style: commonTextStyle),
            trailing: Text(
              data['imei'],
              style: commonTextStyle,
            ),
          ),
          const Divider(height: 20.0, thickness: 20.0, color: Colors.black12),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.track_changes_rounded,
                          size: 35.0,
                        )),
                    const Text(
                      'ติดตาม',
                      style: commonTextStyle,
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings_backup_restore_rounded,
                          size: 35.0,
                        )),
                    const Text(
                      'เล่นย้อนหลัง',
                      style: commonTextStyle,
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.car_crash_rounded,
                          size: 35.0,
                        )),
                    const Text(
                      'รายละเอียด',
                      style: commonTextStyle,
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.keyboard_command_key_rounded,
                          size: 35.0,
                        )),
                    const Text(
                      'คำสั่ง',
                      style: commonTextStyle,
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 20.0, thickness: 20.0, color: Colors.black12),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.notifications, size: 20.0,),
                SizedBox(width: 8.0,),
                Text('เตือน', style: commonTextStyle),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 25.0,
              ),
              onPressed: () {},
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.history, size: 20.0,),
                SizedBox(width: 8.0,),
                Text('ประวัติคำสั่ง', style: commonTextStyle),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 25.0,
              ),
              onPressed: () {},
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.group_work, size: 20.0,),
                SizedBox(width: 8.0,),
                Text('ขอบเขต', style: commonTextStyle),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 25.0,
              ),
              onPressed: () {},
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.share, size: 20.0,),
                SizedBox(width: 8.0,),
                Text('แชร์ตำแหน่ง', style: commonTextStyle),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 25.0,
              ),
              onPressed: () {},
            ),
          ),
          const Divider(height: 0),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.settings, size: 20.0,),
                SizedBox(width: 8.0,),
                Text('ตั้งค่า', style: commonTextStyle),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 25.0,
              ),
              onPressed: () {},
            ),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
