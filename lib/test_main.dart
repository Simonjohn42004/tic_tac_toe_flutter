import 'package:tic_tac_toe/web_socket_client.dart';

void main() async {
  final client = WebSocketClient();

  try {
    final createdRoom = await client.createAndConnect();
    print("Connected to room: ${createdRoom.roomId}");
    await Future.delayed(Duration(seconds: 20));
    client.sendData("{'index' : 3}");
    print("Data Sent");
  } catch (e) {
    print("WebSocket connection failed: $e");
  }
}
