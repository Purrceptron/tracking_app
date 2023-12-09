import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_app/screens/commandpage.dart';
import 'package:gps_tracking_app/screens/directionpage.dart';
import 'package:gps_tracking_app/screens/infopage.dart';
import 'package:gps_tracking_app/screens/otherpage.dart';
import 'package:gps_tracking_app/screens/playbackpage.dart';
import 'package:gps_tracking_app/screens/trackingpage.dart';

late GoogleMapController mapController;
const LatLng _center = LatLng(12.617595, 102.097028);

List<Map<String, dynamic>> data = [
  {
    'id': '1',
    'position': const LatLng(12.617595, 102.097028),
    'assetPath': 'assets/image/car_online3.png',
  }
];

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  final Map<String, Marker> _markers = {};
  MarkerId? _selectedMarker;

  @override
  void initState() {
    _generateMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Display',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition:
            const CameraPosition(target: _center, zoom: 12.0),
        markers: _markers.values.toSet(),
        onTap: (LatLng position) {
          _hideBottomSheet(context);
        },
      ),
    );
  }

  _generateMarkers() async {
    for (int i = 0; i < data.length; i++) {
      BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        data[i]['assetPath'],
      );
      _markers[i.toString()] = Marker(
        markerId: MarkerId(i.toString()),
        position: data[i]['position'],
        icon: markerIcon,
        onTap: () {
          _showBottomSheet(context, MarkerId(i.toString()));
        },
      );
      setState(() {});
    }
  }

  _showBottomSheet(BuildContext context, MarkerId markerId) {
    setState(() {
      _selectedMarker = markerId;
    });

    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const ListTile(
                title: Text('Location latitude : 12.617595, Longitude : 102.097028', style: TextStyle(fontSize: 12),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTappableColumn(
                      'assets/image/car.png', 'Information', () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const InfoPage(),
                    ));
                  }),
                  _buildTappableColumn(
                      'assets/image/tracking.png', 'Tracking', () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TrackingPage(),
                    ));
                  }),
                  _buildTappableColumn(
                      'assets/image/direction.png', 'Playback', () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PlaybackPage(),
                    ));
                  }),
                  _buildTappableColumn('assets/image/command-line.png', 'Command',
                      () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CommandPage(),
                    ));
                  }),
                  _buildTappableColumn(
                      'assets/image/direction-sign.png', 'Direction', () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DirectionPage(),
                    ));
                  }),
                  _buildTappableColumn('assets/image/categories.png', 'Other',
                      () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OtherPage(),
                    ));
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _hideBottomSheet(BuildContext context) {
    if (_selectedMarker != null) {
      setState(() {
        _selectedMarker = null;
      });
      Navigator.of(context).pop();
    }
  }

  Widget _buildTappableColumn(
      String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image(
            height: 50,
            width: 50,
            image: AssetImage(imagePath),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
