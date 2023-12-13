// ignore_for_file: avoid_print, library_prefixes
/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:gps_tracking_app/model/stream_socket.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class SocketDemo extends StatefulWidget {
  const SocketDemo({super.key});

  @override
  State<SocketDemo> createState() => _SocketDemoState();
}

class _SocketDemoState extends State<SocketDemo> {
  late IO.Socket socket;
  int disconnectCounter = 0;
  final TextEditingController _textEditingController = TextEditingController();
  String lastMessage = '';
  String retrivedMessage = '';
  late Timer locationTimer;

  @override
  void initState() {
    super.initState();
    connectAndListen();

    locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      sendLocation();
    });
  }

  void connectAndListen() {
    socket = IO.io('https://linebot.wetrustgps.com/api/test_socket',
        IO.OptionBuilder().setTransports(['websocket']).build());

    try {
      socket.connect();
    } catch (error) {
      print('Error connecting to server: $error');
    }

    socket.onConnect((_) {
      print('----------------------------------------------------');
      print('server connected');
      print('----------------------------------------------------');
    });

    socket.on('test_socket', (data) {
      lastMessage = 'Previous message : $data';
      streamSocket.addResponse(data);
      print('Message from server : $data');
    });

    /*
    socket.on('terminalInput', (rdata) {
      retrivedMessage = 'Retrieved message : $rdata';
      streamSocket.addResponse(rdata);
      print('Input from terminal : $rdata');
    });
    */

    socket.onDisconnect((_) {
      disconnectCounter++;
      if (disconnectCounter == 1) {
        print('disconnect');
      }
    });
  }

  void sendLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
      return;
    }
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      print('Location permission not granted');
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    socket.emit('location', {
      'latitude': position.latitude,
      'longitude': position.longitude,
    });

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Socket Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _textEditingController,
                onChanged: (text) {},
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: streamSocket.getResponse,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Text(lastMessage);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (_textEditingController.text.isNotEmpty) {
                socket.emit('msg', _textEditingController.text);
                _textEditingController.clear();
              }
            },
            tooltip: 'Send message',
            child: const Icon(Icons.send),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
*/