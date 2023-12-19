// ignore_for_file: library_prefixes, avoid_print
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

List<String> titles = <String>[
  'Total',
  'Online',
  'Offline',
];

class _DevicePageState extends State<DevicePage> {
  late IO.Socket socket;
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    connectAndListen();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void connectAndListen() {
    socket = IO.io('https://linebot.wetrustgps.com',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.connect();

    socket.on('wox_webhook', (webhookData) {
      setState(() {
        dataList.add(Map<String, dynamic>.from(webhookData));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 3;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);

    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Device',
            style: TextStyle(color: Colors.white),
          ),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          backgroundColor: Colors.black,
          scrolledUnderElevation: 4.0,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white70,
            tabs: <Widget>[
              Tab(
                icon: const Icon(Icons.gps_fixed_rounded),
                text: titles[0],
              ),
              Tab(
                icon: const Icon(Icons.gps_not_fixed_rounded),
                text: titles[1],
              ),
              Tab(
                icon: const Icon(Icons.gps_off_rounded),
                text: titles[2],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> webhookData = dataList[index];
                String userId = webhookData['user_id'].toString();
                String email = webhookData['user']['email'].toString();
                String latitude = webhookData['latitude'].toString();
                String longitude = webhookData['longitude'].toString();
                String speed = webhookData['speed'].toString();
                String dataTime = webhookData['time'].toString();
                String address = webhookData['address'].toString();
                return ListTile(
                  textColor: Colors.black,
                  titleTextStyle: const TextStyle(fontSize: 12.0),
                  subtitleTextStyle: const TextStyle(fontSize: 12.0),
                  tileColor: index.isOdd ? oddItemColor : Colors.black26,
                  title: Text('User ID: $userId Email: $email'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latitude: $latitude Longitude: $longitude'),
                      Text('Speed: $speed Time: $dataTime'),
                      Text('Address: $address'),
                    ],
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  tileColor: index.isOdd ? oddItemColor : Colors.black26,
                  title: Text('${titles[1]} $index'),
                );
              },
            ),
            ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  tileColor: index.isOdd ? oddItemColor : Colors.black26,
                  title: Text('${titles[2]} $index'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
