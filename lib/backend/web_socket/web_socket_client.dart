import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tic_tac_toe/data_models/room.dart';
import 'package:tic_tac_toe/backend/web_socket/websocket_exceptions.dart';
import 'package:tic_tac_toe/utilities/app_constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
class WebSocketClient {
  WebSocketChannel? _channel;
  Stream<dynamic>? _broadcastStream;

  Future<Room> createRoom() async {
    try {
      final room = await _createAndGetRoom();
      await _connectToRoom(room.roomId);
      print("Player connected to room ${room.roomId}!");
      return room;
    } catch (e) {
      print("WebSocket connection error: $e");
      throw WebsocketConnectingException();
    }
  }

  Future<void> joinRoom(Room room) async {
    try {
      final response = await http.get(
        Uri.https(hostName, "$checkRoomPath${room.roomId}"),
      );

      if (response.statusCode != 200) {
        throw RoomNotFoundException();
      }

      await _connectToRoom(room.roomId);
      print("Joined room ${room.roomId} successfully!");
    } catch (e) {
      throw WebsocketConnectingException();
    }
  }

  Future<void> _connectToRoom(int roomId) async {
    // Close existing connection if any
    await _channel?.sink.close();

    final wsUri = Uri.parse("$websocketName$roomId");
    print("Connecting to WebSocket: $wsUri");

    _channel = WebSocketChannel.connect(wsUri);
    _broadcastStream = _channel!.stream.asBroadcastStream();
  }

  void receiveData({
    required void Function(int index) onIndexReceived,
    required void Function(String message) onStringMessage,
    required void Function()? onOpponentJoined,
    required void Function()? onRoomFull,
    required void Function()? onGameStart,
    required void Function()? onOpponentDisconnected,
  }) {
    if (_broadcastStream == null) {
      throw StateError("WebSocket stream not initialized. Call createRoom or joinRoom first.");
    }

    _broadcastStream!.listen(
      (message) {
        try {
          print("Received message from stream: $message");
          final decoded = jsonDecode(message);

          if (decoded is Map<String, dynamic>) {
            final type = decoded["type"];

            if (type == "move" && decoded["index"] is int) {
              onIndexReceived(decoded["index"]);
            } else if (type == "message" && decoded["text"] is String) {
              final text = decoded["text"];
              switch (text) {
                case "opponent_joined":
                  onOpponentJoined?.call();
                  break;
                case "room_full":
                  onRoomFull?.call();
                  break;
                case "game_start":
                  onGameStart?.call();
                  break;
                case "opponent_disconnected":
                  onOpponentDisconnected?.call();
                  break;
                default:
                  onStringMessage(text);
              }
            } else {
              onStringMessage("Unknown message format received.");
            }
          } else {
            onStringMessage("Unexpected message format.");
          }
        } catch (e) {
          print("Error decoding message: $e");
          onStringMessage("Failed to parse message.");
        }
      },
      onError: (error) {
        onStringMessage("WebSocket error: $error");
      },
      onDone: () {
        onStringMessage("Connection closed.");
      },
    );
  }

  void sendData(Map<String, dynamic> data) {
    print("Sending data: $data");
    _channel?.sink.add(jsonEncode(data));
  }

  void close() {
    _channel?.sink.close();
  }

  Future<Room> _createAndGetRoom() async {
    try {
      print("Trying to create a room...");
      final uri = Uri.https(hostName, createRoomPath);
      final response = await http.get(uri);
      print("Response status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode != 200) throw GenericException();
      return Room.fromJson(jsonDecode(response.body));
    } catch (e, stackTrace) {
      print("Error occurred: $e");
      print("StackTrace: $stackTrace");
      throw GenericException();
    }
  }

  WebSocketChannel? get channel => _channel;
}
