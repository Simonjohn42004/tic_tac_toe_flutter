import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/bloc/game_bloc/game_bloc.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_bloc.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_event.dart';
import 'package:tic_tac_toe/bloc/web_connection_bloc/connection_state.dart';
import 'package:tic_tac_toe/utilities/join_room_alert_box.dart';
import 'package:tic_tac_toe/views/error_alert_dialog.dart';
import 'package:tic_tac_toe/views/game_view.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectionBloc, NetworkConnectionState>(
      listener: (context, state) {
        if ((state is RoomCreatedSuccessfullyState ||
            state is OpponentJoinedState)) {
          final provider =
              (state is RoomCreatedSuccessfullyState)
                  ? state.provider
                  : (state as OpponentJoinedState).provider;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create: (_) => GameBloc(provider),
                    child: const GameView(),
                  ),
            ),
          );
        }
      },
      child: BlocBuilder<ConnectionBloc, NetworkConnectionState>(
        builder: (context, state) {
          if (state is CreatingRoomState || state is JoiningRoomState) {
            print("I am here lol");
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is ConnectionErrorState) {
            showErrorDialogBox(context);
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Tic Tac Toe",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ConnectionBloc>().add(
                        CreateRoomRequestedEvent(),
                      );
                      print("Room Created");
                    },
                    child: const Text("Create Room"),
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
                    child: const Text("Join Room"),
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
