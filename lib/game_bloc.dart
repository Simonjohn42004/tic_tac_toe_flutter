import 'dart:collection';
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
    on<OnBoxTappedEvent>(_onBoxTapped);
    on<GameResetEvent>((event, emit) => emit(InitialiseGameState()));
  }

  Future<void> _onBoxTapped(
    OnBoxTappedEvent event,
    Emitter<GameState> emit,
  ) async {
    final currentState = state;

    if (currentState is! GameOnGoingState &&
        currentState is! InitialiseGameState) {
      return;
    }

    final Queue<int> currentXQueue = Queue<int>.from(
      currentState.playerXQueue ?? Queue<int>(),
    );
    final Queue<int> currentOQueue = Queue<int>.from(
      currentState.playerOQueue ?? Queue<int>(),
    );
    final updatedBoard = List<Player>.from(currentState.gameBoard);

    final isPlayerX =
        currentState is InitialiseGameState ||
        (currentState is GameOnGoingState && currentState.isNextPlayerX);

    // Prevent overwriting already filled box
    if (updatedBoard[event.index] != Player.none) return;

    final activeQueue = isPlayerX ? currentXQueue : currentOQueue;
    final opponentQueue = isPlayerX ? currentOQueue : currentXQueue;

    // If current player has 3, remove the oldest one
    if (activeQueue.length == 3) {
      final int toRemove = activeQueue.removeLast();
      updatedBoard[toRemove] = Player.none;
    }

    // Place current player's new mark
    updatedBoard[event.index] = isPlayerX ? Player.x : Player.o;
    activeQueue.addFirst(event.index);

    // Highlight opponent's oldest mark (for next move)
    int? nextPendingRemoval;
    if (opponentQueue.length == 3) {
      nextPendingRemoval = opponentQueue.last;
    }

    emit(
      _checkWin(
        updatedBoard,
        currentXQueue,
        currentOQueue,
        !isPlayerX,
        nextPendingRemoval,
      ),
    );
  }

  GameState _checkWin(
    List<Player> board,
    Queue<int> playerXQueue,
    Queue<int> playerOQueue,
    bool isNextPlayerX,
    int? pendingRemovalBox,
  ) {
    for (final combo in _winningCombos) {
      final Player a = board[combo[0]];
      final Player b = board[combo[1]];
      final Player c = board[combo[2]];

      if (a != Player.none && a == b && b == c) {
        return GameWinState(
          board,
          playerXQueue,
          playerOQueue,
          player: a,
          winingIndices: combo,
        );
      }
    }

    final hasEmpty = board.any((cell) => cell == Player.none);
    if (hasEmpty) {
      return GameOnGoingState(
        board,
        playerXQueue,
        playerOQueue,
        isNextPlayerX: isNextPlayerX,
        pendingRemovalBox: pendingRemovalBox,
      );
    }

    return GameDrawState(board, playerXQueue, playerOQueue);
  }
}
