import 'dart:async';

import 'package:tic_tac_toe/data_models/game_message.dart';
import 'package:tic_tac_toe/data_models/room.dart';

abstract class GameDataProvider {
  /// Connects to the server, creates a new room, and joins its WebSocket.
  Future<Room> createRoom();

  /// Join a room that was already created by another user
  Future<void> joinRoom(Room room);

  /// Sends a move or any other structured data to the WebSocket.
  void sendData(Map<String, dynamic> data);

  /// Listens to incoming data from the WebSocket.
  /// [onIndexReceived] handles game moves, [onStringMessage] handles plain messages.
  /// More type-safe: emits a structured event.
  Stream<GameMessage> receiveData();

  /// Closes the WebSocket connection gracefully.
  void close();
}
