// ignore_for_file: avoid_print, library_prefixes
import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_app/screens/commandpage.dart';
import 'package:gps_tracking_app/screens/infopage.dart';
import 'package:gps_tracking_app/screens/otherpage.dart';
import 'package:gps_tracking_app/screens/playbackpage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:label_marker/label_marker.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late GoogleMapController googleMapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  late IO.Socket socket;
  int disconnectCounter = 0;

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(13.7500, 101.5000),
    zoom: 6,
  );

  //image marker
  Set<Marker> markers = {};
  Map<String, Marker> carIdToMarkerMap = {};

  String appBarTitle = 'Display';

  //unused
  late Timer locationUpdateTimer;

  Map<String, dynamic> tappedMarkerData = {};
  MapType _currentMapType = MapType.normal;
  bool isLabelMarkerVisible = false;

  List<Map<String, dynamic>> socketDataList = [];

  Timer? debounceTimer;

  @override
  void initState() {
    super.initState();
    connectAndListen();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void connectAndListen() {
    socket = IO.io('https://linebot.wetrustgps.com',
        IO.OptionBuilder().setTransports(['websocket']).build());

    try {
      socket.connect();
    } catch (error) {
      print(error);
    }

    socket.onConnect((_) {
      print('Connect to socket');
    });

    socket.onDisconnect((_) {
      print('Disconnect from socket');
    });

    socket.on('wox_webhook', (data) {
      print('Recieved from wox webhook : $data');
      String carId = data['device']['name'];
      double latitude = data['latitude'];
      double longitude = data['longitude'];
      String imei = data['device']['imei'];
      String carStatus = data['name'];
      String timeStatus = data['time'];
      int deviceId = data['device_id'];
      String speed = data['speed'];
      String detail = data['detail']?.toString() ?? '';

      //direction of car that display in map
      late int dir;
      if (data['course'] is double) {
        dir = data['course'].toInt();
      } else {
        dir = data['course'];
      }

      _getLocationAndSetMarker(carId, latitude, longitude, imei, carStatus, dir,
          timeStatus, deviceId, speed, detail);

      socketDataList.add({
        'carId': carId,
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed,
        'imei': imei,
        'carStatus': carStatus,
        'timeStatus': timeStatus,
        'deviceId': deviceId,
        'detail': detail,
      });

      // Check if label markers need to be displayed
      if (isLabelMarkerVisible) {
        _createLabelMarkersFromList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'BaiJamjuree',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            mapType: _currentMapType,
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
              googleMapController = controller;
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onTap: (LatLng latLng) {
              _customInfoWindowController.hideInfoWindow!();
              googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(initialCameraPosition));
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 90,
            width: 150,
            offset: 25,
          ),
          Container(
            padding: const EdgeInsets.only(top: 24, right: 12),
            alignment: Alignment.topRight,
            child: Column(children: [
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    isLabelMarkerVisible = !isLabelMarkerVisible;
                  });
                  if (isLabelMarkerVisible) {
                    _createLabelMarkersFromList();
                  } else {
                    // If visibility is turned off, clear existing label markers
                    markers.removeWhere(
                        (marker) => marker.markerId.value.endsWith('-label'));
                  }
                },
                child: Icon(
                  isLabelMarkerVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  _changeMapType();
                },
                child: const Icon(
                  Icons.map_sharp,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  //load image marker
  Future<BitmapDescriptor> _getMarkerIcon(String carStatus) async {
    String imagePath;

    //check if car status not online or idle for marker image
    if (carStatus == 'ดับเครื่อง' ||
        carStatus == 'ดับเครื่องยนต์' ||
        carStatus == 'Stop duration longer than' ||
        carStatus == 'Offline duration longer than') {
      imagePath = 'assets/image/กระบะบรรทุก_STOP-removebg-preview.png';
    } else if (carStatus == 'Idle duration longer than') {
      imagePath = 'assets/image/กระบะบรรทุก_IDLE-removebg-preview.png';
    } else {
      imagePath = 'assets/image/กระบะบรรทุก_RUN-removebg-preview.png';
    }

    ByteData byteData = await rootBundle.load(imagePath);
    Uint8List byteList = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(byteList);
  }

  void _changeMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  void _createLabelMarkersFromList() {
    for (var data in socketDataList) {
      _createLabelMarker(
        data['carId'],
        data['latitude'],
        data['longitude'],
        data['speed'],
      );
    }
  }

  void _createLabelMarker(
      String carId, double latitude, double longitude, String speed) {
    String formattedSpeed = speed.split('.').first;
    markers.addLabelMarker(LabelMarker(
      label: '$carId ($formattedSpeed kph)',
      markerId: MarkerId('$carId-label'),
      position: LatLng(latitude, longitude),
      backgroundColor: Colors.white,
      visible: isLabelMarkerVisible,
      textStyle: const TextStyle(
          fontFamily: 'BaiJamjuree', color: Colors.black, fontSize: 28.0),
    ));
  }

  void _getLocationAndSetMarker(
      String carId,
      double latitude,
      double longitude,
      String imei,
      String carStatus,
      int dir,
      String timeStatus,
      int deviceId,
      String speed,
      String detail) async {
    if (carIdToMarkerMap.containsKey(carId)) {
      //update marker if already have
      Marker existingMarker = carIdToMarkerMap[carId]!;
      markers.remove(existingMarker);

      Marker updatedMarker = existingMarker.copyWith(
        positionParam: LatLng(latitude, longitude),
      );

      markers.add(updatedMarker);
      carIdToMarkerMap[carId] = updatedMarker;

      //_createLabelMarker(carId, latitude, longitude, speed);
    } else {
      //create new marker based on lat long from webhook

      Marker newMarker = Marker(
        markerId: MarkerId(carId),
        position: LatLng(latitude, longitude),
        rotation: dir.toDouble(),
        icon: await _getMarkerIcon(carStatus),
        anchor: const Offset(0.5, 1.0),
        onTap: () {
          _onMarkerTapped(carId, latitude, longitude, imei, timeStatus,
              deviceId, speed, carStatus, detail, dir);
          _customInfoWindowController.addInfoWindow!(
              Container(
                padding: const EdgeInsets.all(10.0),
                height: 90,
                width: 150,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carId,
                      style: const TextStyle(
                        fontFamily: 'BaiJamjuree',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    ),
                    Text(
                      'เวลา : $timeStatus',
                      style: const TextStyle(
                        fontFamily: 'BaiJamjuree',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    ),
                    Text(
                      'สถานะ : $carStatus $detail',
                      style: const TextStyle(
                        fontFamily: 'BaiJamjuree',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
              LatLng(latitude, longitude));
        },
      );

      markers.add(newMarker);
      carIdToMarkerMap[carId] = newMarker;

      //_createLabelMarker(carId, latitude, longitude, speed);
    }

    setState(() {
      //appBarTitle = 'ละติจูด : $latitude, ลองจิจูด : $longitude';
    });
  }

  void _onMarkerTapped(
      String carId,
      double latitude,
      double longitude,
      String imei,
      String timeStatus,
      int deviceId,
      String speed,
      String carStatus,
      String detail,
      int dir) {
    print('Marker tapped');
    tappedMarkerData = {
      'carId': carId,
      'latitude': latitude,
      'longitude': longitude,
      'imei': imei,
      'timeStatus': timeStatus,
      'deviceId': deviceId,
      'speed': speed,
      'carStatus': carStatus,
      'detail': detail,
      'dir': dir,
    };

    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 16.0),
    );

    print('Camera animated');

    _showBottomSheet(carId, latitude, longitude, imei);
  }

  void _showBottomSheet(
      String carId, double latitude, double longitude, String imei) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.18,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'IMEI : $imei ทะเบียนรถ : $carId',
                    style: const TextStyle(
                      fontFamily: 'BaiJamjuree',
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButtonColumn(
                        'รายละเอียด', Icons.car_crash_rounded, () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InfoPage(data: tappedMarkerData),
                      ));
                    }),
                    _buildIconButtonColumn(
                        'การติดตาม', Icons.track_changes_rounded, () {
                      googleMapController.animateCamera(
                        CameraUpdate.newLatLng(LatLng(latitude, longitude)),
                      );
                      Navigator.pop(context);
                    }),
                    _buildIconButtonColumn(
                        'เล่นย้อนหลัง', Icons.settings_backup_restore_rounded,
                        () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PlaybackPage(data: tappedMarkerData),
                      ));
                    }),
                    _buildIconButtonColumn(
                        'คำสั่ง', Icons.keyboard_command_key_rounded, () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CommandPage(),
                      ));
                    }),
                    _buildIconButtonColumn(
                        'ระบบนำทาง', Icons.directions_car_filled_rounded, () {
                      _launchGoogleMapsNavigation(latitude, longitude);
                    }),
                    _buildIconButtonColumn('อื่น ๆ', Icons.streetview_rounded,
                        () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OtherPage(data: tappedMarkerData),
                      ));
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButtonColumn(
      String text, IconData iconData, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(iconData, size: 40.0),
          onPressed: onPressed,
          color: Colors.black,
        ),
        const SizedBox(height: 4.0),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11.0,
            fontFamily: 'BaiJamjuree',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _launchGoogleMapsNavigation(
      double destinationLatitude, double destinationLongitude) async {
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude';
    if (await canLaunchUrlString(googleMapsUrl)) {
      await launchUrlString(googleMapsUrl);
    } else {
      print('Could not launch Google Maps');
    }
  }
}
