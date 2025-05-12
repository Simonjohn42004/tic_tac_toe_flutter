import 'package:tic_tac_toe/websocket_exceptions.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as devtools show log;

class WebSocketConnection {
  final wsUrl = Uri.parse(hostName);

  void setAndStartWebSocket() async {
    try {
      final channel = WebSocketChannel.connect(wsUrl);
      await channel.ready;
    } on WebSocketChannelException catch (e) {
      devtools.log(e.toString());
    } on GenericException catch (_) {
      devtools.log("Something unexpected occurred");
    }
  }
}

const hostName = "ws://localhost:8080";
