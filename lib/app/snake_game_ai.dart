import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:event/event.dart';

import '../ai/neural_network.dart';
import '../ai/population.dart';
import '../game/components/mixins/playroom_component.dart';
import '../game/components/playroom.dart';
import '../game/components/playroom_cell.dart';
import '../game/snake_game.dart';
import '../utils/direction.dart';

const _nbInputNeurons = 24;
const _nbOutputNeurons = 4;

const _populationSize = 200;

class SnakeGameAI {
  SnakeGameAI({
    required this.game,
  }) {
    _population = Population(
      nbInputs: _nbInputNeurons,
      nbOutputs: _nbOutputNeurons,
      populationSize: populationSize,
    );

    game.onBeforeUpdate.subscribe((_) {
      _activate();

      if (_frameOverflow) {
        _frameOverflowGameOver();
      }
    });
    game.onIncreaseScore.subscribe((_) {
      _increaseScore();
    });
    game.onGameOver.subscribe((_) {
      _newIndividual();

      if (_individual >= _populationSize) {
        _newGeneration();
      }

      _resetGame();
    });
  }

  final SnakeGame game;

  final valueChangedEvent = Event();

  int _score = 0;
  int get score => _score;

  int _bestScore = 0;
  int get bestScore => _bestScore;

  int _individual = 1;
  int get individual => _individual;
  int get populationSize => _populationSize;

  int _generation = 1;
  int get generation => _generation;

  int _framesSinceLastFruit = 0;
  bool get _frameOverflow =>
      _framesSinceLastFruit > playroomSize * playroomSize;

  late final Population _population;

  NeuralNetwork get currentNeuralNetwork =>
      _population.individuals[_individual - 1];

  void _activate() {
    final outputs = currentNeuralNetwork.activate(
      _computeInputs(),
    );
    var largestOutput = 0.0;

    for (var i = 0; i < outputs.length; i++) {
      if (outputs[i] > largestOutput) {
        largestOutput = outputs[i];
        game.events.direction = switch (i) {
          0 => Direction.up,
          1 => Direction.right,
          2 => Direction.down,
          3 => Direction.left,
          _ => throw Exception(),
        };
      }
    }

    _framesSinceLastFruit++;
  }

  List<double> _computeInputs() {
    final slopes = [
      for (var x = -1; x <= 1; x++)
        for (var y = -1; y <= 1; y++)
          if (x != 0 || y != 0) _Slope(x, y),
    ];

    return [
      ..._computeWallInputs(slopes),
      ..._computeTailInputs(slopes),
      ..._conputeFruitInputs(slopes),
      ..._conputeHeadDirectionInputs(slopes),
    ];
  }

  List<double> _computeDistanceToHeadInputs(
    List<PlayroomCellComponent> playroomCells,
    List<_Slope> slopes,
  ) {
    final headPosition = game.playroom.snake.head.cell;
    final tailInputs = <double>[];

    for (final slope in slopes) {
      var dx = 0;
      var dy = 0;
      var cell = PlayroomCell(
        headPosition.col + dx,
        headPosition.row + dy,
      );
      double? tailPosition;

      while (true) {
        dx += slope.dx;
        dy += slope.dy;

        cell = PlayroomCell(
          headPosition.col + dx,
          headPosition.row + dy,
        );

        if (cell.col < 0 ||
            cell.row < 0 ||
            cell.col >= playroomSize ||
            cell.row >= playroomSize) {
          break;
        }

        final tail = playroomCells.firstWhereOrNull(
          (tail) => tail.col == cell.col && tail.row == cell.row,
        );

        if (tail != null) {
          tailPosition = math.sqrt(
                math.pow(headPosition.col - tail.col, 2) +
                    math.pow(headPosition.row - tail.row, 2),
              ) /
              playroomSize;
          break;
        }
      }

      tailInputs.add(tailPosition ?? 0.0);
    }

    return tailInputs;
  }

  List<double> _computeWallInputs(List<_Slope> slopes) {
    return _computeDistanceToHeadInputs(
      game.playroom.walls,
      slopes,
    );
  }

  List<double> _computeTailInputs(List<_Slope> slopes) {
    return _computeDistanceToHeadInputs(
      game.playroom.snake.tail,
      slopes,
    );
  }

  List<double> _conputeFruitInputs(List<_Slope> slopes) {
    final headPosition = game.playroom.snake.head.cell;
    final fruitPosition = game.playroom.fruit.cell;
    return [
      fruitPosition.row < headPosition.row ? 1.0 : 0.0,
      fruitPosition.row > headPosition.row ? 1.0 : 0.0,
      fruitPosition.col < headPosition.col ? 1.0 : 0.0,
      fruitPosition.col > headPosition.col ? 1.0 : 0.0,
    ];
  }

  List<double> _conputeHeadDirectionInputs(List<_Slope> slopes) {
    final headDirection = game.playroom.snake.direction;
    return [
      headDirection == Direction.up ? 1.0 : 0.0,
      headDirection == Direction.right ? 1.0 : 0.0,
      headDirection == Direction.down ? 1.0 : 0.0,
      headDirection == Direction.left ? 1.0 : 0.0,
    ];
  }

  void _increaseScore() {
    _score++;
    _framesSinceLastFruit = 0;

    valueChangedEvent.broadcast();
  }

  void _resetGame() {
    _bestScore = _score > _bestScore ? _score : _bestScore;
    _score = 0;
    _framesSinceLastFruit = 0;
    game.reset();

    valueChangedEvent.broadcast();
  }

  void _newIndividual() {
    currentNeuralNetwork.fitness = math.max(
      _frameOverflow ? .01 : _score.toDouble(),
      .01,
    );
    _individual++;

    valueChangedEvent.broadcast();
  }

  void _frameOverflowGameOver() {
    _framesSinceLastFruit = 0;
    game.gameOver();
  }

  void _newGeneration() {
    _population.newGeneration();
    _individual = 1;
    _generation++;

    valueChangedEvent.broadcast();
  }
}

class _Slope {
  _Slope(
    this.dx,
    this.dy,
  );

  final int dx;
  final int dy;
}
