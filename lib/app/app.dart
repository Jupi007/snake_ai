import 'dart:convert';
import 'dart:io';

import 'package:eventsubscriber/eventsubscriber.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:yaru_icons/yaru_icons.dart';

import '../ai/population.dart';
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
  late SnakeGameAI _snakeAi;

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
            icon: const Icon(YaruIcons.meter_6),
            tooltip: 'Toggle speed mode',
          ),
          IconButton(
            onPressed: _savePopulationBackup,
            icon: const Icon(YaruIcons.save),
            tooltip: 'Save population',
          ),
          IconButton(
            onPressed: _restorePopulationBackup,
            icon: const Icon(YaruIcons.folder),
            tooltip: 'Load population',
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

  void _savePopulationBackup() async {
    final outputFilePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'population.json',
    );

    if (outputFilePath == null) {
      return;
    }

    await File(outputFilePath).writeAsString(
      jsonEncode(_snakeAi.population.toJson()),
    );
  }

  void _restorePopulationBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) {
      return;
    }

    final file = File(result.files.single.path!);
    final json = jsonDecode(await file.readAsString());
    _snakeAi.population = Population.fromJson(json);
  }
}
