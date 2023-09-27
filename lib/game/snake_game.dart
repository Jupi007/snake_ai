import 'package:event/event.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/events.dart';
import 'components/playroom.dart';

class SnakeGame extends FlameGame
    with
        // SingleGameInstance,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  final onGameOver = Event();
  final onIncreaseScore = Event();

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

    onGameOver.broadcast();
  }

  void _init() {
    events = Events();
    playroom = Playroom();

    add(events);
    add(playroom);
  }

  void increaseScore() {
    onIncreaseScore.broadcast();
  }

  void reset() {
    _init();
  }
}
