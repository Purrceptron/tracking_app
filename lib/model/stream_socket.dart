import 'dart:async';

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void addResponse(String response) {
    _socketResponse.sink.add(response);
  }

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();
