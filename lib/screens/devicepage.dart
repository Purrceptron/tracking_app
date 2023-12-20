import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

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
    socket.disconnect();
    super.dispose();
  }

  void connectAndListen() {
    socket = IO.io('https://linebot.wetrustgps.com',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.connect();

    socket.on('wox_webhook', (webhookData) {
      setState(() {
        // Check if the data already have
        int existingIndex = dataList.indexWhere((data) =>
            data['device']['name'] == webhookData['device']['name'] &&
            data['name'] == webhookData['name'] &&
            data['detail'] == webhookData['detail']);

        if (existingIndex != -1) {
          // If already have data, update it
          dataList[existingIndex] = Map<String, dynamic>.from(webhookData);

          //test
          dataList[existingIndex]['isUpdated'] = true;
        } else {
          // If don't have data, add it to the list
          dataList.add(Map<String, dynamic>.from(webhookData));
        }
      });
    });
  }

  List<Map<String, dynamic>> getFilteredDataList() {
    return dataList
        .where((webhookData) =>
            webhookData['name'].toString() != 'ดับเครื่องยนต์' &&
            webhookData['name'].toString() != 'Idle duration longer than' &&
            webhookData['name'].toString() != 'Offline duration longer than' &&
            webhookData['name'].toString() != 'ดับเครื่อง')
        .toList();
  }

  List<Map<String, dynamic>> getEngineOffDataList() {
    return dataList
        .where((webhookData) =>
            webhookData['name'].toString() == 'ดับเครื่องยนต์' ||
            webhookData['name'].toString() == 'Idle duration longer than' ||
            webhookData['name'].toString() == 'Offline duration longer than' ||
            webhookData['name'].toString() == 'ดับเครื่อง')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 3;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);

    bool isEngineOff = getEngineOffDataList().isNotEmpty;

    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'อุปกรณ์',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'BaiJamjuree',
              fontWeight: FontWeight.w600,
            ),
          ),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          backgroundColor: Colors.black,
          scrolledUnderElevation: 4.0,
          bottom: const TabBar(
            labelStyle: TextStyle(
              fontFamily: 'BaiJamjuree',
              fontWeight: FontWeight.w600,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white70,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.gps_fixed_rounded),
                text: 'ทั้งหมด',
              ),
              Tab(
                icon: Icon(Icons.gps_not_fixed_rounded),
                text: 'ออนไลน์',
              ),
              Tab(
                icon: Icon(Icons.gps_off_rounded),
                text: 'ออฟไลน์',
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
                String carId = webhookData['device']['name'].toString();
                String carStatus = webhookData['name'].toString();
                String timeStatus = webhookData['detail']?.toString() ?? '';
                String lat = webhookData['latitude'].toString();
                String lng = webhookData['longitude'].toString();
                //test update
                bool isUpdated = webhookData['isUpdated'] ?? false;

                return ListTile(
                  leading: const Icon(
                    Icons.car_repair_rounded,
                    size: 40.0,
                  ),

                  /* Old color
                  tileColor: index.isOdd ? oddItemColor : Colors.black26,
                  title: Text(
                    'ทะเบียน : $carId',
                    style: const TextStyle(fontFamily: 'BaiJamjuree'),
                  ),
                  */

                  //test if data update, change listTile color
                  tileColor: isUpdated
                      ? Colors.yellow
                      : index.isOdd
                          ? oddItemColor
                          : Colors.black26,
                  title: Text(
                    'ทะเบียน : $carId',
                    style: const TextStyle(
                      fontFamily: 'BaiJamjuree',
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สถานะของรถ : $carStatus $timeStatus',
                        style: const TextStyle(fontFamily: 'BaiJamjuree'),
                      ),
                      Text(
                        'ละติจูด $lat ลองจิจูด $lng',
                        style: const TextStyle(fontFamily: 'BaiJamjuree'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: getFilteredDataList().length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> webhookData = getFilteredDataList()[index];
                String carId = webhookData['device']['name'].toString();
                String carStatus = webhookData['name'].toString();
                String timeStatus = webhookData['detail']?.toString() ?? '';
                String lat = webhookData['latitude'].toString();
                String lng = webhookData['longitude'].toString();

                if (carStatus == 'ดับเครื่องยนต์' ||
                    carStatus == 'Idle duration longer than' ||
                    carStatus == 'ดับเครื่อง') {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  leading: const Icon(
                    Icons.car_repair_rounded,
                    size: 40.0,
                  ),
                  tileColor: index.isOdd ? oddItemColor : Colors.black26,
                  title: Text(
                    'ทะเบียน : $carId',
                    style: const TextStyle(fontFamily: 'BaiJamjuree'),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'สถานะของรถ : $carStatus $timeStatus',
                        style: const TextStyle(fontFamily: 'BaiJamjuree'),
                      ),
                      Text(
                        'ละติจูด $lat ลองจิจูด $lng',
                        style: const TextStyle(fontFamily: 'BaiJamjuree'),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (isEngineOff)
              ListView.builder(
                itemCount: getEngineOffDataList().length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> webhookData =
                      getEngineOffDataList()[index];
                  String carId = webhookData['device']['name'].toString();
                  String carStatus = webhookData['name'].toString();
                  String timeStatus = webhookData['detail']?.toString() ?? '';
                  String lat = webhookData['latitude'].toString();
                  String lng = webhookData['longitude'].toString();

                  return ListTile(
                    leading: const Icon(
                      Icons.car_repair_rounded,
                      size: 40.0,
                    ),
                    tileColor: index.isOdd ? oddItemColor : Colors.black26,
                    title: Text(
                      'ทะเบียน : $carId',
                      style: const TextStyle(fontFamily: 'BaiJamjuree'),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'สถานะของรถ : $carStatus $timeStatus',
                          style: const TextStyle(fontFamily: 'BaiJamjuree'),
                        ),
                        Text(
                          'ละติจูด $lat ลองจิจูด $lng',
                          style: const TextStyle(fontFamily: 'BaiJamjuree'),
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
