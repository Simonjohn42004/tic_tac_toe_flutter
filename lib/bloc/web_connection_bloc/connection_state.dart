abstract class ConnectionState {}

class IdleState extends ConnectionState{}

class CreatingRoomState extends ConnectionState {}

class RoomCreatedSuccessfullyState extends ConnectionState {
  final int roomId;

  RoomCreatedSuccessfullyState({required this.roomId});
}

class WaitingForOpponentState extends ConnectionState{}

class JoiningRoomState extends ConnectionState{}

class OpponentJoinedState extends ConnectionState{}

class ConnectionErrorState extends ConnectionState {
  final String error;
  ConnectionErrorState({required this.error});
}

class DisconnectedState extends ConnectionState {
  final String reason;
  DisconnectedState({this.reason = "Disconnected from server"});
}

