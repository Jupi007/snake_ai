import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/events.dart';
import 'components/playroom.dart';

class SnakeGame extends FlameGame
    with
        SingleGameInstance,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  final events = Events();
  final playroom = Playroom();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(events);
    add(playroom);
  }
}
