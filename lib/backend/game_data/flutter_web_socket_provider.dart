import 'dart:async';

import 'package:tic_tac_toe/data_models/game_message.dart';
import 'package:tic_tac_toe/data_models/room.dart';
import 'package:tic_tac_toe/backend/web_socket/web_socket_client.dart';
import 'package:tic_tac_toe/backend/game_data/game_data_provider.dart';

class FlutterWebSocketProvider extends GameDataProvider {
  final WebSocketClient _client;

  FlutterWebSocketProvider({required WebSocketClient client})
    : _client = client;

  @override
  Future<Room> createRoom() async {
    final room = _client.createRoom();
    return room;
  }

  @override
  Future<void> joinRoom(Room room) async {
    return _client.joinRoom(room);
  }

  @override
  Stream<GameMessage> receiveData() {
    final controller = StreamController<GameMessage>();

    _client.receiveData(
      onIndexReceived: (index) {
        controller.add(MoveMessage(index: index)); // Forward to stream
      },
      onStringMessage: (message) {
        controller.add(TextMessage(message: message)); // Forward to stream
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
