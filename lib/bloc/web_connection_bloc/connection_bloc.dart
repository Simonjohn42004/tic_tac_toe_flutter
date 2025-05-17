import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/backend/game_data/game_data_provider.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_event.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_state.dart';
import 'package:tic_tac_toe/data_models/room.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, NetworkConnectionState> {
  final GameDataProvider _provider;
  ConnectionBloc(this._provider) : super(IdleState()) {
    on<CreateRoomRequestedEvent>(_createRoomRequestedEvent);
    on<JoinRoomRequestedEvent>(_joinRoomRequestedEvent);
    on<ConnectionLostEvent>(_connectionLostEvent);
  }

  FutureOr<void> _createRoomRequestedEvent(
    CreateRoomRequestedEvent event,
    Emitter<NetworkConnectionState> emit,
  ) async {
    emit(CreatingRoomState());
    try {
      print("The current provider is $_provider");

      final room = await _provider.createRoom();
      print("Room is created with the ID : ${room.roomId}");
      emit(
        RoomCreatedSuccessfullyState(roomId: room.roomId, provider: _provider),
      );
    } catch (e) {
      print("i am here in the exception block lol");
      emit(ConnectionErrorState(error: "Unknown Error Occured"));
      // TODO implementing the exceptions more precisely to be done
    }
  }

  FutureOr<void> _joinRoomRequestedEvent(
    JoinRoomRequestedEvent event,
    Emitter<NetworkConnectionState> emit,
  ) async {
    emit(JoiningRoomState());
    try {
      await _provider.joinRoom(Room(roomId: event.roomId));
      emit(OpponentJoinedState(provider: _provider));
    } catch (e) {
      emit(ConnectionErrorState(error: "Could not join room! Error occurred"));
    }
  }

  FutureOr<void> _connectionLostEvent(
    ConnectionLostEvent event,
    Emitter<NetworkConnectionState> emit,
  ) {
    emit(DisconnectedState(reason: event.reason));
  }
}
