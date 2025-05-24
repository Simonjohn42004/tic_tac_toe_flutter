sealed class GameMessage {
  Map<String, dynamic> toJson();
}

// Already present — no changes needed
class MoveMessage extends GameMessage {
  final int index;

  MoveMessage({required this.index});

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "move",
      "index": index,
    };
  }

  @override
  String toString() => 'MoveMessage(index: $index)';
}

// Already present — no changes needed
class TextMessage extends GameMessage {
  final String message;

  TextMessage({required this.message});

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "message",
      "text": message,
    };
  }

  @override
  String toString() => 'TextMessage(message: "$message")';
}

// New message classes below
class OpponentJoinedMessage extends GameMessage {
  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "message",
      "text": "opponent_joined",
    };
  }

  @override
  String toString() => 'OpponentJoinedMessage()';
}

class RoomFullMessage extends GameMessage {
  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "message",
      "text": "room_full",
    };
  }

  @override
  String toString() => 'RoomFullMessage()';
}

class GameStartMessage extends GameMessage {
  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "message",
      "text": "game_start",
    };
  }

  @override
  String toString() => 'GameStartMessage()';
}

class OpponentDisconnectedMessage extends GameMessage {
  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "message",
      "text": "opponent_disconnected",
    };
  }

  @override
  String toString() => 'OpponentDisconnectedMessage()';
}
