import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../direction.dart';

class Events extends Component with KeyboardHandler {
  bool _left = false;
  bool _right = false;
  bool _up = false;
  bool _down = false;

  Direction? direction;

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    final isKeyDown = event is RawKeyDownEvent;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        _left = isKeyDown;
        return true;
      case LogicalKeyboardKey.arrowRight:
        _right = isKeyDown;
        return true;
      case LogicalKeyboardKey.arrowUp:
        _up = isKeyDown;
        return true;
      case LogicalKeyboardKey.arrowDown:
        _down = isKeyDown;
        return true;
    }

    return false;
  }

  @override
  void update(double dt) {
    if (_up && !_right && !_down && !_left) {
      direction = Direction.up;
    } else if (_right && !_up && !_down && !_left) {
      direction = Direction.right;
    } else if (_down && !_up && !_right && !_left) {
      direction = Direction.down;
    } else if (_left && !_up && !_right && !_down) {
      direction = Direction.left;
    }
  }
}
