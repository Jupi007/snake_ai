import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

import 'game/score_provider.dart';
import 'game/snake_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake AI',
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<ScoreProvider>(
        create: (context) => ScoreProvider(),
        builder: (context, child) {
          final scoreProvider =
              Provider.of<ScoreProvider>(context, listen: false);
          final game = SnakeGame(scoreProvider);

          return YaruTheme(
            child: Scaffold(
              appBar: AppBar(
                title: Consumer<ScoreProvider>(
                  builder: (context, scoreProvider, child) => Text(
                    'Snake AI - Score: ${scoreProvider.score} - Best: ${scoreProvider.bestScore}',
                  ),
                ),
              ),
              body: GameWidget(game: game),
            ),
          );
        },
      ),
    );
  }
}
