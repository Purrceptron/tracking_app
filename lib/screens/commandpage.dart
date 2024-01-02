import 'package:flutter/material.dart';

class CommandPage extends StatelessWidget {
  const CommandPage({super.key});

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
        title: const Text(
          'ส่งคำสั่ง',
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
            title: const Text('เช็คตำแหน่ง', style: commonTextStyle),
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
            title: const Text('สั่งดับเครื่องยนต์', style: commonTextStyle),
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
            title: const Text('ยกเลิกดับเครื่องยนต์', style: commonTextStyle),
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
            title: const Text('เปิด สั่นสะเทือน', style: commonTextStyle),
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
            title: const Text('ปิด สั่นสะเทือน', style: commonTextStyle),
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
            title: const Text('SOS Number', style: commonTextStyle),
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
            title: const Text('เช็คสถานะ', style: commonTextStyle),
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
            title: const Text('เช็คพารามิเตอร์', style: commonTextStyle),
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
            title: const Text('เช็คการตั้งค่า', style: commonTextStyle),
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
            title: const Text('เวอร์ชันของเฟิร์มแวร์', style: commonTextStyle),
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
            title: const Text('รีเช็ต', style: commonTextStyle),
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
            title: const Text('ตั้งค่าเลขไมล์', style: commonTextStyle),
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
            title: const Text('เพิ่มเติม', style: commonTextStyle),
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
