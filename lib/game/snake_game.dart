import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/events.dart';
import 'components/playroom.dart';

class SnakeGame extends FlameGame
    with
        // SingleGameInstance,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  SnakeGame({
    required this.onIncreaseScore,
    required this.onGameOver,
  });

  final void Function() onIncreaseScore;
  final void Function() onGameOver;

  late Events events;
  late Playroom playroom;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _init();
  }

  void gameOver() {
    remove(events);
    remove(playroom);
    onGameOver();

    _init();
  }

  void _init() {
    events = Events();
    playroom = Playroom();

    add(events);
    add(playroom);
  }

  void increaseScore() {
    onIncreaseScore();
  }
}
