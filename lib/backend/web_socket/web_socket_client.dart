import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tic_tac_toe/data_models/room.dart';
import 'package:tic_tac_toe/backend/web_socket/websocket_exceptions.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  late final WebSocketChannel _channel;

  /// Creates a room and connects to its WebSocket endpoint.
  Future<Room> createRoom() async {
    try {
      final room = await _createAndGetRoom();
      print("this is after i create the room with the room id");
      final wsUri = Uri.parse("$websocketName${room.roomId}");
      _channel = WebSocketChannel.connect(wsUri);
      return room;
    } catch (e) {
      throw WebsocketConnectingException();
    }
  }

  Future<void> joinRoom(Room room) async {
    try {
      // 1. Validate room existence via HTTP POST
      final checkRoomUri = Uri.parse("$hostName$checkRoomPath/${room.roomId}");
      final response = await http.get(checkRoomUri);

      if (response.statusCode != 200) {
        throw RoomNotFoundException(); // You could define a more specific exception
      }

      // 2. If valid, connect to the WebSocket
      final wsUri = Uri.parse("$websocketName/${room.roomId}");
      _channel = WebSocketChannel.connect(wsUri);
    } catch (e) {
      throw WebsocketConnectingException(); // Your custom exception
    }
  }

  /// Listens to WebSocket messages and delegates based on content.
  void receiveData({
    required void Function(int number) onIndexReceived,
    required void Function(String message) onStringMessage,
  }) {
    _channel.stream.listen(
      (move) {
        try {
          final decoded = jsonDecode(move);
          if (decoded is Map && decoded["index"] is int) {
            onIndexReceived(decoded["index"]);
          } else {
            onStringMessage(move.toString());
          }
        } catch (_) {
          onStringMessage(move.toString());
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

  /// Sends a JSON-encoded message to the server.
  void sendData(Map<String, dynamic> data) {
    _channel.sink.add(jsonEncode(data));
  }

  /// Closes the WebSocket connection cleanly.
  void close() {
    _channel.sink.close();
  }

  /// Helper to create a room by calling the backend.
  Future<Room> _createAndGetRoom() async {
    try {
      print("i am in the create room of the web socket client block");
      final response = await http.get(Uri.http(hostName, createRoomPath));
      print("hi");
      print(response.statusCode);
      if (response.statusCode != 200) throw GenericException();
      return Room.fromJson(jsonDecode(response.body));
    } catch (_) {
      print(
        "i am here in the catch block of the create room which throws generic exception",
      );
      throw GenericException();
    }
  }

  WebSocketChannel get channel => _channel;
}


