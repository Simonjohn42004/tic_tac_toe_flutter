import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_toe/bloc/game_bloc/game_bloc.dart';
import 'package:tic_tac_toe/bloc/game_bloc/game_event.dart';
import 'package:tic_tac_toe/bloc/game_bloc/game_state.dart';
import 'package:tic_tac_toe/data_models/player.dart';

class GameView extends StatefulWidget {
  
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    try {
    final bloc = context.watch<GameBloc>();
    print("GameBloc found: $bloc");
  } catch (e) {
    print("GameBloc NOT found in GameView: $e");
  }
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        var gameTitle = "";

        if (state is GameOnGoingState) {
          gameTitle = state.isNextPlayerX ? "Player X turn" : "Player O turn";
        } else if (state is InitialiseGameState) {
          gameTitle = "Player X turn";
        } else if (state is GameDrawState) {
          gameTitle = "Game Draw! Play again?";
        } else if (state is GameWinState) {
          gameTitle =
              state.player == Player.x ? "Player X won" : "Player O won";
        }

        return Scaffold(
          appBar: AppBar(title: Text("Tic Tac Toe"), centerTitle: true),
          body: Center(
            child: Column(
              children: [
                Text(
                  gameTitle,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height *
                      0.4, // 40% of screen height
                  width:
                      MediaQuery.of(context).size.width *
                      0.9, // takes up 90% of the screen width
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.read<GameBloc>().add(
                            OnBoxTappedEvent(index: index),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            color:
                                (state is GameWinState &&
                                        (state.winingIndices[0] == index ||
                                            state.winingIndices[1] == index ||
                                            state.winingIndices[2] == index))
                                    ? Colors.green
                                    : Colors.grey[300],
                          ),
                          child: Center(
                            child: Text(
                              state.gameBoard[index].symbol,
                              style: GoogleFonts.balooDa2(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color:
                                    (state is GameOnGoingState &&
                                            state.pendingRemovalBox == index)
                                        ? Colors.red
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ElevatedButton(
                  onPressed: () {
                    context.read<GameBloc>().add(GameResetEvent());
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
