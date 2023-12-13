import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    const int tabsCount = 3;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

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
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  tileColor: index.isOdd ? oddItemColor : Colors.black26,
                  title: Text('${titles[0]} $index'),
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
