// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaybackPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const PlaybackPage({super.key, required this.data});

  @override
  State<PlaybackPage> createState() => _PlaybackPageState();
}

class _PlaybackPageState extends State<PlaybackPage> {
  late GoogleMapController googleMapController;
  Set<Marker> playbackMarkers = {};

  @override
  Widget build(BuildContext context) {
    print(
        '******************** Rotation Value: ${widget.data['dir']} ********************');
    print(
        '******************** Data Value: ${widget.data} ********************');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data['carId'],
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'BaiJamjuree'),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.data['latitude'], widget.data['longitude']),
          zoom: 16.0,
        ),
        markers: playbackMarkers,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            googleMapController = controller;
            _addPlaybackMarkers();
          });
        },
      ),
    );
  }

  void _addPlaybackMarkers() async {
    BitmapDescriptor markerIcon =
        await _getMarkerIcon(widget.data['carStatus']);

    playbackMarkers.add(Marker(
        markerId: const MarkerId('playbackMarker'),
        position: LatLng(widget.data['latitude'], widget.data['longitude']),
        icon: markerIcon,
        rotation: widget.data['dir'].toDouble()));
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
}
