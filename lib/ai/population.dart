import 'dart:math' as math;

import 'package:collection/collection.dart';

import '../../utils/math.dart';
import 'connection.dart';
import 'neural_network.dart';
import 'neuron.dart';

class Population {
  Population({
    required this.nbInputs,
    required this.nbOutputs,
    required this.populationSize,
    this.excessCoeff = 1.0,
    this.weightDiffCoeff = 2.0,
    this.diffThresh = 1.5,
  }) {
    for (var i = 0; i < populationSize; i++) {
      final neuralNetwork = NeuralNetwork(
        inputNeurons: [
          for (var i = 0; i < nbInputs; i++) InputNeuron(),
        ],
        outputNeurons: [
          for (var i = 0; i < nbOutputs; i++) OutputNeuron(),
        ],
        hiddenNeurons: [],
        connections: [],
      )..addConnection();

      individuals.add(neuralNetwork);
    }

    _speciatePopulation();
  }

  final int nbInputs;
  final int nbOutputs;
  final int populationSize;

  final double excessCoeff;
  final double weightDiffCoeff;
  final double diffThresh;

  final List<NeuralNetwork> individuals = [];
  final List<List<NeuralNetwork>> species = [];

  double get averageFitness =>
      individuals
          .map((network) => network.fitness)
          .reduce((f1, f2) => f1 + f2) /
      individuals.length;

  double _computeConnectionsWeightDifference(
    List<Connection> connections1,
    List<Connection> connections2,
  ) {
    var weightDifference = 0.0;
    var matchingConnections = 0;

    for (final connection1 in connections1) {
      for (final connection2 in connections2) {
        if (connection1.innovation == connection2.innovation) {
          matchingConnections++;
          weightDifference += (connection1.weight - connection2.weight).abs();
        }
      }
    }

    if (matchingConnections == 0) {
      return 100;
    }

    return weightDifference / matchingConnections;
  }

  int _countExcessConnections(
    List<Connection> connections1,
    List<Connection> connections2,
  ) {
    var matchingConnections = 0;

    for (final connection1 in connections1) {
      for (final connection2 in connections2) {
        if (connection1.innovation == connection2.innovation) {
          matchingConnections += 2;
        }
      }
    }

    return connections1.length + connections2.length - matchingConnections;
  }

  void _speciatePopulation() {
    for (final network in individuals) {
      var speciesFound = false;
      for (final specie in species) {
        if (specie.isNotEmpty) {
          final representiveNetwork = (specie.toList()..shuffle()).first;

          final excessConnections = _countExcessConnections(
            representiveNetwork.connections,
            network.connections,
          );
          final connectionsDifferences = _computeConnectionsWeightDifference(
            representiveNetwork.connections,
            network.connections,
          );
          final totalConnections = math.max(
            representiveNetwork.connections.length + network.connections.length,
            1,
          );
          final diff = (excessCoeff * excessConnections) / totalConnections +
              weightDiffCoeff * connectionsDifferences;

          if (diff < diffThresh) {
            specie.add(network);
            speciesFound = true;
            break;
          }
        }
      }

      if (!speciesFound) {
        species.add([network]);
      }
    }
  }

  NeuralNetwork _chooseParent(List<NeuralNetwork> specie) {
    final threshold = randomDouble() *
        specie.map((network) => network.fitness).reduce((f1, f2) => f1 + f2);
    var sum = 0.0;
    return specie.firstWhere((network) {
      sum += network.fitness;
      return sum > threshold;
    });
  }

  NeuralNetwork _crossover({
    required NeuralNetwork goodNetwork,
    required NeuralNetwork badNetwork,
  }) {
    final newInputNeurons = goodNetwork.inputNeurons.map((n) {
      return InputNeuron()..id = n.id;
    }).toList();
    final newHiddenNeurons = goodNetwork.hiddenNeurons.map((n) {
      return HiddenNeuron()..id = n.id;
    }).toList();
    final newOutputNeurons = goodNetwork.outputNeurons.map((n) {
      return OutputNeuron()..id = n.id;
    }).toList();

    final newConnections = goodNetwork.connections.map((connection) {
      final otherConnection = badNetwork.connections
          .firstWhereOrNull((c) => c.innovation == connection.innovation);
      final ancestorConnection = randomDouble() < 0.5 && otherConnection != null
          ? otherConnection
          : connection;

      return Connection(
        input: [
          ...newInputNeurons,
          ...newHiddenNeurons,
        ].firstWhere((n) => n.id == ancestorConnection.input.id),
        output: [
          ...newHiddenNeurons,
          ...newOutputNeurons,
        ].firstWhere((n) => n.id == ancestorConnection.output.id),
        innovation: ancestorConnection.innovation,
        weight: ancestorConnection.weight,
        enabled: ancestorConnection.enabled,
      );
    }).toList();

    return NeuralNetwork(
      inputNeurons: newInputNeurons,
      hiddenNeurons: newHiddenNeurons,
      outputNeurons: newOutputNeurons,
      connections: newConnections,
      initNeuronIds: false,
    );
  }

  void newGeneration() {
    final oldAverageFitness = averageFitness;
    final oldPopulation = [...individuals];
    individuals.clear();

    var networksToCreate = populationSize;

    for (final specie in species) {
      var newIndividualsCount = (specie
                  .map((network) => network.fitness / specie.length)
                  .reduce((t, v) => t + v) /
              oldAverageFitness) *
          specie.length;
      networksToCreate -= newIndividualsCount.ceil();

      if (networksToCreate < 0) {
        newIndividualsCount += networksToCreate;
        networksToCreate = 0;
      }

      final newNetworks = <NeuralNetwork>[];

      for (var i = 0; i < newIndividualsCount; i++) {
        final parent1 = _chooseParent(specie);
        final parent2 = _chooseParent(specie);

        final newNetwork = (parent1.fitness > parent2.fitness
            ? _crossover(goodNetwork: parent1, badNetwork: parent2)
            : _crossover(goodNetwork: parent2, badNetwork: parent1))
          ..mutate();

        newNetworks.add(newNetwork);
      }

      individuals.addAll(newNetworks);
    }

    _clearEmptySpecies();
    _speciatePopulation();

    for (final specie in species) {
      specie.removeWhere(
        (network) =>
            null !=
            oldPopulation.firstWhereOrNull(
              (oldNetwork) => network == oldNetwork,
            ),
      );
    }

    _clearEmptySpecies();
  }

  void _clearEmptySpecies() => species.removeWhere((specie) => specie.isEmpty);
}
