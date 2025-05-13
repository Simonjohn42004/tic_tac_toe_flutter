abstract class WebSocketProvider {
  /// Connects to the WebSocket room using the roomId
  Future<void> connectToRoom(String roomId);

  /// Sends a move to the server (index: 0–8)
  Future<void> sendMove(int index);

  /// Stream to listen for incoming messages (e.g., opponent's move)
  Stream<int> get onMove;

  /// Disconnects the socket from the server
  Future<void> disconnect();

  /// Check if WebSocket is connected
  bool isConnected();
}
