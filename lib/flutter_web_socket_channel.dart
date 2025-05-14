import 'dart:async';

import 'package:tic_tac_toe/room.dart';
import 'package:tic_tac_toe/web_socket_client.dart';
import 'package:tic_tac_toe/web_socket_provider.dart';

class FlutterWebSocketChannel extends WebSocketProvider {
  final WebSocketClient _client;

  FlutterWebSocketChannel({required WebSocketClient client}) : _client = client;

  @override
  Future<Room> createRoom() {
    final room = _client.createRoom();
    return room;
  }

  @override
  Future<void> joinRoom(Room room) async{
    return _client.joinRoom(room);
  }

  @override
  Stream receiveData(
    void Function(int index) onIndexReceived,
    void Function(String message) onStringMessage,
  ) {
    final controller = StreamController<dynamic>();

    _client.receiveData(
      onIndexReceived: (index) {
        onIndexReceived(index); // Trigger the callback
        controller.add(index); // Forward to stream
      },
      onStringMessage: (message) {
        onStringMessage(message); // Trigger the callback
        controller.add(message); // Forward to stream
      },
    );

    return controller.stream;
  }

  @override
  void sendData(Map<String, dynamic> data) {
    _client.sendData(data);
  }

  @override
  void close() {
    _client.close();
  }
}

const hostName = "localhost:8080";
