import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/backend/game_data/game_data_provider.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_event.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_state.dart';
import 'package:tic_tac_toe/data_models/room.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final GameDataProvider _provider;
  ConnectionBloc(this._provider) : super(IdleState()) {
    on<CreateRoomRequestedEvent>(_createRoomRequestedEvent);
    on<JoinRoomRequestedEvent>(_joinRoomRequestedEvent);
    on<ConnectionLostEvent>(_connectionLostEvent);
  }

  FutureOr<void> _createRoomRequestedEvent(
    CreateRoomRequestedEvent event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(CreatingRoomState());
    try {
      final room = await _provider.createRoom();
      emit(RoomCreatedSuccessfullyState(roomId: room.roomId));
    } catch (e) {
      emit(ConnectionErrorState(error: "Unknown Error Occured"));
      // TODO implementing the exceptions more precisely to be done
    }
  }

  FutureOr<void> _joinRoomRequestedEvent(
    JoinRoomRequestedEvent event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(JoiningRoomState());
    try {
      await _provider.joinRoom(Room(roomId: event.roomId));
      emit(OpponentJoinedState());
    } catch (e) {
      emit(ConnectionErrorState(error: "Could not join room! Error occurred"));
    }
  }

  FutureOr<void> _connectionLostEvent(
  ConnectionLostEvent event,
  Emitter<ConnectionState> emit,
) {
  emit(DisconnectedState(reason: event.reason));
}

}
