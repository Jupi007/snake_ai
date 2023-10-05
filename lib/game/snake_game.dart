import 'package:event/event.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/events.dart';
import 'components/playroom.dart';

class SnakeGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  SnakeGame({
    required this.listenKeyboardEvents,
    required bool slowMode,
  }) : _slowMode = slowMode;

  final bool listenKeyboardEvents;
  bool _slowMode;

  final onBeforeUpdate = Event();
  final onGameOver = Event();
  final onIncreaseScore = Event();

  late Events events;
  late Playroom playroom;

  DateTime? _previousUpdateTime;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    init();
  }

  @override
  void update(double dt) {
    if (!_canUpdate()) {
      return;
    }

    super.update(dt);
  }

  void gameOver() {
    kill();
    onGameOver.broadcast();
  }

  void init() {
    events = Events();
    playroom = Playroom();

    add(events);
    add(playroom);
  }

  void kill() {
    remove(events);
    remove(playroom);
  }

  void increaseScore() {
    onIncreaseScore.broadcast();
  }

  void toggleSlowMode() {
    _slowMode = !_slowMode;
  }

  bool _canUpdate() {
    if (_previousUpdateTime == null) {
      _previousUpdateTime = DateTime.now();
      return true;
    }

    if (!_slowMode) {
      return true;
    }

    final expectedNextUpdateTime = _previousUpdateTime!.add(
      const Duration(milliseconds: 100),
    );

    if (expectedNextUpdateTime.isBefore(DateTime.now())) {
      _previousUpdateTime = DateTime.now();
      return true;
    }

    return false;
  }
}
