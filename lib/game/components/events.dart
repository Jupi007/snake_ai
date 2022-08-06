import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Events extends Component with KeyboardHandler {
  bool left = false;
  bool right = false;
  bool up = false;
  bool down = false;

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);

    final isKeyDown = event is RawKeyDownEvent;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      left = isKeyDown;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      right = isKeyDown;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      up = isKeyDown;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      down = isKeyDown;
    }

    return false;
  }
}
