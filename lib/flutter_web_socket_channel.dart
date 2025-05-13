import 'package:tic_tac_toe/web_socket_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FlutterWebSocketChannel extends WebSocketProvider {
  @override
  Future<void> connectToRoom(String roomId) async {
   
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  bool isConnected() {
    // TODO: implement isConnected
    throw UnimplementedError();
  }

  @override
  // TODO: implement onMove
  Stream<int> get onMove => throw UnimplementedError();

  @override
  Future<void> sendMove(int index) {
    // TODO: implement sendMove
    throw UnimplementedError();
  }
}

const hostName = "localhost:8080";
