import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/events.dart';
import 'components/playroom.dart';

class SnakeGame extends FlameGame
    with
        SingleGameInstance,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  late Events events;
  late Playroom playroom;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _init();
  }

  void gameOver() {
    remove(events);
    remove(playroom);

    _init();
  }

  void _init() {
    events = Events();
    playroom = Playroom();

    add(events);
    add(playroom);
  }
}
