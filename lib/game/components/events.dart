import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../../utils/direction.dart';
import '../snake_game.dart';

class Events extends Component with KeyboardHandler, HasGameRef<SnakeGame> {
  bool _left = false;
  bool _right = false;
  bool _up = false;
  bool _down = false;

  Direction direction = Direction.left;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // direction = switch (randomInt(1, 4)) {
    //   1 => Direction.up,
    //   2 => Direction.right,
    //   3 => Direction.down,
    //   4 => Direction.left,
    //   _ => throw Exception(),
    // };
    //direction = Direction.left;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    if (!gameRef.listenKeyboardEvents) {
      return false;
    }

    final isKeyDown = event is RawKeyDownEvent;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        _left = isKeyDown;
        break;
      case LogicalKeyboardKey.arrowRight:
        _right = isKeyDown;
        break;
      case LogicalKeyboardKey.arrowUp:
        _up = isKeyDown;
        break;
      case LogicalKeyboardKey.arrowDown:
        _down = isKeyDown;
        break;
    }

    if (_up && !_right && !_down && !_left) {
      direction = Direction.up;
    } else if (_right && !_up && !_down && !_left) {
      direction = Direction.right;
    } else if (_down && !_up && !_right && !_left) {
      direction = Direction.down;
    } else if (_left && !_up && !_right && !_down) {
      direction = Direction.left;
    }

    return true;
  }
}
