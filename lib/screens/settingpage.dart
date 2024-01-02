import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Default font
    const commonTextStyle = TextStyle(
      fontFamily: 'BaiJamjuree',
      fontSize: 13.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ตั้งค่า',
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
          const ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: SizedBox(
              width: 72.0,
              height: 72.0,
              child: Icon(
                Icons.account_box,
                color: Colors.black54,
                size: 60.0,
              ),
            ),
            title: Text(
              'DEMO',
              style: commonTextStyle,
            ),
            subtitle: Text(
              'บัญชี : demo',
              style: commonTextStyle,
            ),
          ),
          const Divider(height: 20.0, thickness: 20.0, color: Colors.black12),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.receipt_long_outlined),
                SizedBox(
                  width: 8.0,
                ),
                Text('สร้างรายงาน', style: commonTextStyle),
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
                Icon(Icons.auto_graph_outlined),
                SizedBox(
                  width: 8.0,
                ),
                Text('ดูรายงานที่สร้าง', style: commonTextStyle),
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
                Icon(Icons.group_work),
                SizedBox(
                  width: 8.0,
                ),
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
                Icon(Icons.art_track),
                SizedBox(
                  width: 8.0,
                ),
                Text('POI', style: commonTextStyle),
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
                Icon(Icons.mail_sharp),
                SizedBox(
                  width: 8.0,
                ),
                Text('ข้อความ', style: commonTextStyle),
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
                Icon(Icons.settings),
                SizedBox(
                  width: 8.0,
                ),
                Text('ตั้งค่าเตือน/เปลี่ยนรหัส/ทั่วไป', style: commonTextStyle),
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
                Icon(Icons.mail_sharp),
                SizedBox(
                  width: 8.0,
                ),
                Text('แจ้งปัญหาการใช้งาน/feedback', style: commonTextStyle),
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
          const SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black45,
                  backgroundColor: Colors.black38),
              child: const Text(
                'ออกจากระบบ',
                style: TextStyle(
                    fontFamily: 'BaiJamjuree',
                    color: Colors.white,
                    fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
