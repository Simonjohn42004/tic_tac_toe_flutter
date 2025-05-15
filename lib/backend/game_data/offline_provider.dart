import 'dart:async';

import 'package:tic_tac_toe/backend/game_data/game_data_provider.dart';
import 'package:tic_tac_toe/data_models/game_message.dart';
import 'package:tic_tac_toe/data_models/room.dart';

class OfflineGameDataProvider extends GameDataProvider {
  final _streamController = StreamController<GameMessage>.broadcast();
  @override
  void close() {
    _streamController.close();
  }

  @override
  Future<Room> createRoom() async {
    return Room(roomId: 1);
  }

  @override
  Future<void> joinRoom(Room room) async {}

  @override
  Stream<GameMessage> receiveData() {
    return _streamController.stream;
  }

  @override
  void sendData(Map<String, dynamic> data) {
    if (data.containsKey("index") && data["index"] is int) {
      _streamController.add(MoveMessage(index: data["index"]));
    } else {
      _streamController.add(TextMessage(message: data["message"]));
    }
  }
}
