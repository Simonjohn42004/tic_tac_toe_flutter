import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/backend/game_data/game_data_provider.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_event.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_state.dart';
import 'package:tic_tac_toe/data_models/game_message.dart';
import 'package:tic_tac_toe/data_models/room.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, NetworkConnectionState> {
  final GameDataProvider _provider;
  StreamSubscription? _messageSubscription;

  ConnectionBloc(this._provider) : super(IdleState()) {
    on<CreateRoomRequestedEvent>(_createRoomRequestedEvent);
    on<JoinRoomRequestedEvent>(_joinRoomRequestedEvent);
    on<ConnectionLostEvent>(_connectionLostEvent);
    on<OpponentJoinedEvent>(_opponentJoinedEvent);
  }

  FutureOr<void> _createRoomRequestedEvent(
    CreateRoomRequestedEvent event,
    Emitter<NetworkConnectionState> emit,
  ) async {
    emit(CreatingRoomState());
    print("[ConnectionBloc] Creating a room...");

    try {
      final room = await _provider.createRoom();
      print("[ConnectionBloc] Room created with ID: ${room.roomId}");

      emit(RoomCreatedSuccessfullyState(roomId: room.roomId, provider: _provider));

      _messageSubscription?.cancel();
      _messageSubscription = _provider.receiveData().listen((message) {
        if (message is OpponentJoinedMessage) {
          add(OpponentJoinedEvent(isRemote: false));
        } else if (message is RoomFullMessage) {
          add(ConnectionLostEvent(reason: "Room is full."));
        } else if (message is GameStartMessage) {
          print("[ConnectionBloc] Game started."); // optional: emit a new state if needed
        } else if (message is OpponentDisconnectedMessage) {
          add(ConnectionLostEvent(reason: "Opponent disconnected."));
        }
      });
    } catch (e) {
      print("[ConnectionBloc] Failed to create room: $e");
      emit(ConnectionErrorState(error: "Failed to create room. Please try again."));
    }
  }

  FutureOr<void> _joinRoomRequestedEvent(
    JoinRoomRequestedEvent event,
    Emitter<NetworkConnectionState> emit,
  ) async {
    emit(JoiningRoomState());
    print("[ConnectionBloc] Attempting to join room: ${event.roomId}");

    try {
      await _provider.joinRoom(Room(roomId: event.roomId));
      print("[ConnectionBloc] Successfully joined room ${event.roomId}");

      emit(OpponentJoinedState(provider: _provider, isRemote: true));

      _messageSubscription?.cancel();
      _messageSubscription = _provider.receiveData().listen((message) {
        if (message is GameStartMessage) {
          print("[ConnectionBloc] Game started."); // optional: emit a new state if needed
        } else if (message is OpponentDisconnectedMessage) {
          add(ConnectionLostEvent(reason: "Opponent disconnected."));
        } else if (message is RoomFullMessage) {
          add(ConnectionLostEvent(reason: "Room is full."));
        }
      });
    } catch (e) {
      print("[ConnectionBloc] Failed to join room: $e");
      emit(ConnectionErrorState(error: "Could not join room. Please check the room ID and try again."));
    }
  }

  FutureOr<void> _connectionLostEvent(
    ConnectionLostEvent event,
    Emitter<NetworkConnectionState> emit,
  ) {
    print("[ConnectionBloc] Connection lost: ${event.reason}");
    emit(DisconnectedState(reason: event.reason));
  }

  Future<void> _opponentJoinedEvent(
    OpponentJoinedEvent event,
    Emitter<NetworkConnectionState> emit,
  ) async {
    emit(OpponentJoinedState(provider: _provider, isRemote: event.isRemote));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
