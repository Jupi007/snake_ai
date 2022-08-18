import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'game/snake_game.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final game = SnakeGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake AI',
      debugShowCheckedModeBanner: false,
      home: YaruTheme(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Snake AI'),
          ),
          body: GameWidget(game: game),
        ),
      ),
    );
  }
}
