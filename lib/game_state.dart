import 'package:tic_tac_toe/player.dart';

// Main state management for the game, we use the gameBoard for providing the current board to each state
abstract class GameState {
  List<Player> gameBoard;

  GameState(this.gameBoard);
}

// The start of the game, when the board is emtpty
class InitialiseGameState extends GameState {
  bool isNextPlayerX = true;
  InitialiseGameState()
    : super([
        Player.none,
        Player.none,
        Player.none,
        Player.none,
        Player.none,
        Player.none,
        Player.none,
        Player.none,
        Player.none,
      ]);
}

// The game is won by one of the players state
class GameWinState extends GameState {
  final Player player;

  GameWinState(super.gameBoard, {required this.player});
}

// The game is drawn state
class GameDrawState extends GameState {
  GameDrawState(super.gameBoard);
}

class GameOnGoingState extends GameState {
  bool isNextPlayerX;

  GameOnGoingState(super.gameBoard, {required this.isNextPlayerX});
}
