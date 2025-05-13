import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tic_tac_toe/room.dart';
import 'package:tic_tac_toe/websocket_exceptions.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  late WebSocketChannel _channel;

  Future<Room> createAndConnect() async {
    try {
      // 1. Get room ID
      final room = await createAndGetRoomId();

      // 2. Build proper WebSocket URL
      final wsUri = Uri.parse("ws://localhost:8080/play/${room.roomId}");

      // 3. Connect WebSocket
      _channel = WebSocketChannel.connect(wsUri);

      return room;
    } catch (e) {
      throw WebsocketConnectingException();
    }
  }

  int receiveData() {
    int number =
        _channel.stream.listen((move) {
              jsonDecode(move["index"]);
            })
            as int;
    return number;
  }

  void sendData(String data) {
    _channel.sink.add(data);
  }

  Future<Room> createAndGetRoomId() async {
    try {
      final response = await http.get(
        Uri.http("localhost:8080", "/create-room"),
      );
      if (response.statusCode != 200) throw GenericException();

      final decoded = jsonDecode(response.body);
      return Room.fromJson(decoded);
    } catch (e) {
      throw GenericException();
    }
  }

  WebSocketChannel get channel => _channel;
}
