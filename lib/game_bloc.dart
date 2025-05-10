import 'package:bloc/bloc.dart';
import 'package:tic_tac_toe/game_event.dart';
import 'package:tic_tac_toe/game_state.dart';
import 'package:tic_tac_toe/player.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final _winningCombos = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  GameBloc() : super(InitialiseGameState()) {
    on<OnBoxTappedEvent>((event, emit) {
      final currentState = state;
      final updatedBoard = List<Player>.from(state.gameBoard);
      if (updatedBoard[event.index] != Player.none) return;
      if (currentState is GameOnGoingState) {
        updatedBoard[event.index] =
            currentState.isNextPlayerX ? Player.x : Player.o;
        emit(_checkWin(updatedBoard, !currentState.isNextPlayerX));
      } else if (currentState is InitialiseGameState) {
        updatedBoard[event.index] = Player.x;
        emit(GameOnGoingState(updatedBoard, isNextPlayerX: false));
      }
    });

    on<GameResetEvent>((event, emit) {
      emit(InitialiseGameState());
    });
  }

  GameState _checkWin(List<Player> board, bool isNextPlayerX) {
    for (int i = 0; i < _winningCombos.length; i++) {
      final player = board[_winningCombos[i][0]];
      if (board[_winningCombos[i][0]] != Player.none &&
          board[_winningCombos[i][0]] == board[_winningCombos[i][1]] &&
          board[_winningCombos[i][1]] == board[_winningCombos[i][2]]) {
        return GameWinState(board, player: player);
      }
    }
    if (board.contains(Player.none)) {
      return GameOnGoingState(board, isNextPlayerX: !isNextPlayerX);
    }
    return GameDrawState(board);
  }
}
