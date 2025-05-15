sealed class GameMessage {}

class MoveMessage extends GameMessage {
  final int index;

  MoveMessage({required this.index});
}

class TextMessage extends GameMessage {
  final String message;

  TextMessage({required this.message});
}
