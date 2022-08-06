import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/events.dart';
import 'components/playroom.dart';
import 'components/playroom/snake.dart';

class SnakeGame extends FlameGame
    with
        SingleGameInstance,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  final events = Events();
  final playroom = Playroom();
  final snake = Snake();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(events);
    add(playroom);
    add(snake);
  }
}
