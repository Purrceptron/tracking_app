import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  int _selectedAppBarIndex = 0;

  void _onAppBarTap(int index) {
    setState(() {
      _selectedAppBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: const Text(
              'Device',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),
          AppBar(
            centerTitle: true,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _onAppBarTap(0),
                    child: const Text('Total',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  InkWell(
                    onTap: () => _onAppBarTap(1),
                    child: const Text('Online',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  InkWell(
                    onTap: () => _onAppBarTap(2),
                    child: const Text('Offline',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.black87,
            toolbarHeight: 30,
          ),
          Expanded(
            child: _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    switch (_selectedAppBarIndex) {
      case 0:
        return ListView(
          children: const [
            ListTile(
              title: Text('Total Information 1'),
            ),
            ListTile(
              title: Text('Total Information 2'),
            ),
          ],
        );
      case 1:
        return ListView(
          children: const [
            ListTile(
              title: Text('Online Information 1'),
            ),
            ListTile(
              title: Text('Online Information 2'),
            ),
          ],
        );
      case 2:
        return ListView(
          children: const [
            ListTile(
              title: Text('Offline Information 1'),
            ),
            ListTile(
              title: Text('Offline Information 2'),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
