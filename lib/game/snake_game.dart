import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'components/events.dart';
import 'components/playroom.dart';
import 'score_provider.dart';

class SnakeGame extends FlameGame
    with
        // SingleGameInstance,
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  SnakeGame(this._scoreProvider);

  final ScoreProvider _scoreProvider;
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
    _scoreProvider.resetScore();

    _init();
  }

  void _init() {
    events = Events();
    playroom = Playroom();

    add(events);
    add(playroom);
  }

  void increaseScore() {
    _scoreProvider.increaseScore();
  }
}
