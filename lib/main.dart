import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'game/components/playroom.dart';
import 'game/snake_game.dart';

void main() {
  runApp(const _Home());
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake AI',
      debugShowCheckedModeBanner: false,
      home: YaruTheme(
        child: _App(),
      ),
    );
  }
}

class _App extends StatefulWidget {
  final game = SnakeGame();

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  int _score = 0;
  int _bestScore = 0;

  @override
  void initState() {
    super.initState();

    widget.game.onIncreaseScore.subscribe((args) {
      increaseScore();
    });
    widget.game.onGameOver.subscribe((args) {
      resetScore();
      widget.game.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Snake AI - Score: $_score - Best: $_bestScore',
        ),
      ),
      body: Center(
        child: SizedBox(
          height: playroomSize * cellSize,
          width: playroomSize * cellSize,
          child: GameWidget(game: widget.game),
        ),
      ),
    );
  }

  void increaseScore() {
    setState(() {
      _score++;
    });
  }

  void resetScore() {
    setState(() {
      _bestScore = _score > _bestScore ? _score : _bestScore;
      _score = 0;
    });
  }
}
