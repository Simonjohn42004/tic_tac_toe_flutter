import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tic_tac_toe/bloc/game_bloc/game_bloc.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_bloc.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_event.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_state.dart';
import 'package:tic_tac_toe/data_models/player.dart';

import 'package:tic_tac_toe/utilities/join_room_alert_box.dart';
import 'package:tic_tac_toe/utilities/show_waiting_dialog.dart';
import 'package:tic_tac_toe/views/error_alert_dialog.dart';
import 'package:tic_tac_toe/views/game_view.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  bool _errorShown = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectionBloc, NetworkConnectionState>(
      listener: (context, state) async {
        if (state is OpponentJoinedState) {
          final provider = state.provider;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: context.read<ConnectionBloc>()),
                      BlocProvider(create: (_) => GameBloc(provider, Player.o)),
                    ],
                    child: const GameView(),
                  ),
            ),
          );
        }

        if (state is RoomCreatedSuccessfullyState) {
          final provider = state.provider;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: context.read<ConnectionBloc>()),
                      BlocProvider(create: (_) => GameBloc(provider, Player.x)),
                    ],
                    child: const GameView(),
                  ),
            ),
          );

          showWaitingDialog(context, state.roomId);
        }

        if (state is ConnectionErrorState && !_errorShown) {
          _errorShown = true;
          await showErrorDialogBox(context, state.error);
          _errorShown = false;
        }

        // 👇 NEW: Handle disconnection gracefully
        if (state is DisconnectedState && !_errorShown) {
          _errorShown = true;
          await showErrorDialogBox(context, state.reason);
          _errorShown = false;

          // Return to connection page root
          if (mounted) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        }
      },
      child: BlocBuilder<ConnectionBloc, NetworkConnectionState>(
        builder: (context, state) {
          final isLoading =
              state is CreatingRoomState || state is JoiningRoomState;

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Tic Tac Toe",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
            body: Center(
              child:
                  isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<ConnectionBloc>().add(
                                CreateRoomRequestedEvent(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "Create Room",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await showJoinRoomAlertBox(context, (roomId) {
                                context.read<ConnectionBloc>().add(
                                  JoinRoomRequestedEvent(roomId: roomId),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "Join Room",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
            ),
          );
        },
      ),
    );
  }
}
