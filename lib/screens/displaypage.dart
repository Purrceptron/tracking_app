// ignore_for_file: avoid_print, library_prefixes
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_app/screens/commandpage.dart';
import 'package:gps_tracking_app/screens/directionpage.dart';
import 'package:gps_tracking_app/screens/infopage.dart';
import 'package:gps_tracking_app/screens/otherpage.dart';
import 'package:gps_tracking_app/screens/playbackpage.dart';
import 'package:gps_tracking_app/screens/trackingpage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
//import 'package:http/http.dart' as http;

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
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  Set<Marker> markers = {};
  String appBarTitle = 'Display';
  late Timer locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _getLocationAndSetMarker();
    connectAndListen();

    locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      _sendLocationUpdate();
    });
  }

  @override
  void dispose() {
    locationUpdateTimer.cancel();
    super.dispose();
  }

  void connectAndListen() {
    socket = IO.io('https://linebot.wetrustgps.com',
        IO.OptionBuilder().setTransports(['websocket']).build());

    try {
      socket.connect();
    } catch (error) {
      print('----------------------------------------------------');
      print('Error connecting to server: $error');
      print('----------------------------------------------------');
    }
    socket.on('connect_error', (error) {
      print('----------------------------------------------------');
      print('Connection Error: $error');
    });
    socket.on('connect_timeout', (_) {
      print('----------------------------------------------------');
      print('Connection Timeout');
    });

    socket.onConnect((_) {
      print('----------------------------------------------------');
      print('server connected');
      print('----------------------------------------------------');
    });

    socket.on('wox_webhook', (data) {
      print('Received wox_webhook data: $data');
    });

    socket.onDisconnect((_) {
      disconnectCounter++;
      if (disconnectCounter == 1) {
        print('disconnect');
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
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
    );
  }

  void _getLocationAndSetMarker() async {
    try {
      Position position = await _determinePosition();

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
        ),
      );

      markers.clear();

      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          icon: await _getMarkerIcon(),
          onTap: () {
            _showBottomSheet(position);
          },
        ),
      );

      setState(() {
        appBarTitle =
            'ละติจูด : ${position.latitude}, ลองจิจูด : ${position.longitude}';
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _showBottomSheet(Position position) {
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
                    'ละติจูด : ${position.latitude}, ลองจิจูด : ${position.longitude}',
                    style: const TextStyle(
                      fontFamily: 'BaiJamjuree',
                      fontWeight: FontWeight.w500,
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
                        builder: (context) => const InfoPage(),
                      ));
                    }),
                    _buildIconButtonColumn(
                        'การติดตาม', Icons.track_changes_rounded, () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TrackingPage(),
                      ));
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

    /*try {
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
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');*/
    return position;
  }

  Future<BitmapDescriptor> _getMarkerIcon() async {
    String imagePath = 'assets/image/car_online3.png';
    ByteData byteData = await rootBundle.load(imagePath);
    Uint8List byteList = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(byteList);
  }

  void _sendLocationUpdate() async {
    try {
      Position position = await _determinePosition();
      print(
          'Sending location update - Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Error sending location update: $e');
    }
  }
}
