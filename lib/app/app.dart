import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/components/playroom.dart';
import '../game/snake_game.dart';
import 'snake_game_ai.dart';

final game = SnakeGame(
  listenKeyboardEvents: true,
  slowMode: false,
);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final SnakeGameAI _snakeAi;

  @override
  void initState() {
    super.initState();
    _snakeAi = SnakeGameAI(game: game);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: EventSubscriber(
          event: _snakeAi.valueChangedEvent,
          builder: (context, args) => Text(
            'Score: ${_snakeAi.score} - Best: ${_snakeAi.bestScore} - Generation: ${_snakeAi.generation} - Individual: ${_snakeAi.individual}/${_snakeAi.populationSize}',
          ),
        ),
        actions: [
          IconButton(
            onPressed: game.toggleSlowMode,
            icon: const Icon(Icons.speed),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: playroomSize * cellSize,
          width: playroomSize * cellSize,
          child: GameWidget(game: game),
        ),
      ),
    );
  }
}
