// ignore_for_file: avoid_print, library_prefixes
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_app/screens/commandpage.dart';
import 'package:gps_tracking_app/screens/directionpage.dart';
import 'package:gps_tracking_app/screens/infopage.dart';
import 'package:gps_tracking_app/screens/otherpage.dart';
import 'package:gps_tracking_app/screens/playbackpage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late GoogleMapController googleMapController;
  late IO.Socket socket;
  int disconnectCounter = 0;

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(13.7500, 101.5000),
    zoom: 6,
  );

  Set<Marker> markers = {};
  Map<String, Marker> carIdToMarkerMap = {};
  String appBarTitle = 'Display';
  late Timer locationUpdateTimer;
  Map<String, dynamic> tappedMarkerData = {};

  @override
  void initState() {
    super.initState();
    connectAndListen();
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
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        onTap: (LatLng latLng) {
          googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(initialCameraPosition));
        },
      ),
    );
  }

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
    } else {
      //create new marker based on lat long from webhook
      Marker newMarker = Marker(
        markerId: MarkerId(carId),
        position: LatLng(latitude, longitude),
        rotation: dir.toDouble(),
        icon: await _getMarkerIcon(carStatus),
        onTap: () {
          _onMarkerTapped(carId, latitude, longitude, imei, timeStatus,
              deviceId, speed, carStatus, detail);
        },
      );

      markers.add(newMarker);
      carIdToMarkerMap[carId] = newMarker;
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
      String detail) {
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
      //another data
    };

    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 16),
    );

    _showBottomSheet(carId, latitude, longitude, imei);
  }

  void centerCameraOnMarker() {
    if (tappedMarkerData.isNotEmpty) {
      double latitude = tappedMarkerData['latitude'];
      double longitude = tappedMarkerData['longitude'];
      googleMapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(latitude, longitude)),
      );
    }
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
                        builder: (context) => const PlaybackPage(),
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DirectionPage(),
                      ));
                    }),
                    _buildIconButtonColumn('อื่น ๆ', Icons.streetview_rounded,
                        () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OtherPage(),
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

  /*
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    socket.emit('location', {
      'latitude': position.latitude,
      'longitude': position.longitude,
    });

    /*
    try {
      final response = await http.post(
        Uri.parse('https://linebot.wetrustgps.com/api/test_socket'),
        body: {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        },
      );

      if (response.statusCode == 200) {
        print('API call successful: ${response.body}');
      } else {
        print('API call failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error making API call: $error');
    }
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    */

    return position;
  }
  */

  /*
  Future<BitmapDescriptor> _getMarkerIcon() async {
    String imagePath = 'assets/image/car_online2.png';
    ByteData byteData = await rootBundle.load(imagePath);
    Uint8List byteList = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(byteList);
  }
  */

  /*
  void _sendLocationUpdate() async {
    try {
      Position position = await _determinePosition();
      print(
          'Sending location update - Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Error sending location update: $e');
    }
  }
  */
}
