import 'package:collection/collection.dart';

import '../../utils/math.dart';
import 'connection.dart';
import 'neuron.dart';

const minimalFitness = 0.00001;

class NeuralNetwork {
  NeuralNetwork({
    required this.inputNeurons,
    required this.outputNeurons,
    required this.hiddenNeurons,
    required this.connections,
    bool initNeuronIds = true,
  }) {
    if (!initNeuronIds) {
      return;
    }

    var id = 0;

    for (final neuron in neurons) {
      neuron.id = ++id;
    }
  }

  factory NeuralNetwork.fromJson(Map<String, dynamic> json) {
    final inputNeurons = (json['inputNeurons'] as List<dynamic>?)!
        .map((n) => InputNeuron.fromJson(n as Map<String, dynamic>))
        .toList();
    final hiddenNeurons = (json['hiddenNeurons'] as List<dynamic>?)
        ?.map((n) => HiddenNeuron.fromJson(n as Map<String, dynamic>))
        .toList();
    final outputNeurons = (json['outputNeurons'] as List<dynamic>?)!
        .map((n) => OutputNeuron.fromJson(n as Map<String, dynamic>))
        .toList();

    final withOutputsNeuron = [
      ...inputNeurons,
      ...?hiddenNeurons,
    ];
    final withInputsNeuron = [
      ...?hiddenNeurons,
      ...outputNeurons,
    ];

    final connections = (json['connections'] as List<dynamic>?)!.map(
      (c) {
        return Connection(
          input: withOutputsNeuron.firstWhere(
            (n) => n.id == c['input'] as int,
          ),
          output: withInputsNeuron.firstWhere(
            (n) => n.id == c['output'] as int,
          ),
          innovation: c['innovation'] as int,
          weight: c['weight'] as double,
          enabled: c['enabled'] as bool,
        );
      },
    ).toList();

    return NeuralNetwork(
      inputNeurons: inputNeurons,
      hiddenNeurons: hiddenNeurons ?? [],
      outputNeurons: outputNeurons,
      connections: connections,
      initNeuronIds: false,
    );
  }

  Map<String, dynamic> toJson() => {
        'inputNeurons': inputNeurons.map((n) => n.toJson()).toList(),
        'outputNeurons': outputNeurons.map((n) => n.toJson()).toList(),
        'hiddenNeurons': hiddenNeurons.map((n) => n.toJson()).toList(),
        'connections': connections.map((c) => c.toJson()).toList(),
      };

  final List<InputNeuron> inputNeurons;
  final List<OutputNeuron> outputNeurons;
  final List<HiddenNeuron> hiddenNeurons;
  List<Neuron> get neurons => [
        ...inputNeurons,
        ...hiddenNeurons,
        ...outputNeurons,
      ];
  final List<Connection> connections;
  List<Connection> get activeConnections =>
      connections.where((c) => c.enabled).toList();

  double fitness = minimalFitness;

  int get neuronsMaxId => neurons
      .map((n) => n.id)
      .reduce((current, next) => current > next ? current : next);

  List<double> activate(List<double> inputs) {
    assert(inputs.length == inputNeurons.length);

    for (var i = 0; i < inputs.length; i++) {
      inputNeurons[i].value = inputs[i];
    }

    final output = outputNeurons.map((e) => e.value).toList();

    for (final neuron in inputNeurons) {
      neuron.value = null;
    }

    return output;
  }

  void mutate() {
    if (randomDouble() < 0.8) {
      mutateConnectionsWeight();
    }
    if (randomDouble() < 0.05) {
      addConnection();
    }
    if (randomDouble() < 0.01) {
      addHiddenNeuron();
    }
  }

  void mutateConnectionsWeight() {
    for (final connection in connections) {
      if (randomDouble() < 0.1) {
        connection.weight = randomDouble(-1.0, 1.0);
      } else {
        connection.weight += centredRandomDouble(-0.1, 0.1);
      }
    }
  }

  void addConnection() {
    final withOutputNeurons = <WithOutputsNeuron>[
      ...inputNeurons,
      ...hiddenNeurons,
    ]..shuffle();
    final withInputNeurons = <WithInputsNeuron>[
      ...hiddenNeurons,
      ...outputNeurons,
    ]..shuffle();

    outerLoop:
    for (final withOutputNeuron in withOutputNeurons) {
      for (final withInputNeuron in withInputNeurons) {
        if (withInputNeuron == withOutputNeuron) {
          continue;
        }

        if (connections.firstWhereOrNull(
              (c) =>
                  c.input == withInputNeuron ||
                  c.output == withInputNeuron ||
                  c.input == withOutputNeuron ||
                  c.output == withOutputNeuron,
            ) !=
            null) {
          continue;
        }

        connections.add(
          Connection(
            input: withOutputNeuron,
            output: withInputNeuron,
          ),
        );
        break outerLoop;
      }
    }
  }

  void addHiddenNeuron() {
    if (activeConnections.isEmpty) {
      return;
    }

    final oldConnection =
        activeConnections[randomInt(0, activeConnections.length - 1)];
    oldConnection.enabled = false;

    final newNeuron = HiddenNeuron()..id = neuronsMaxId + 1;
    hiddenNeurons.add(newNeuron);

    connections.add(
      Connection(
        input: oldConnection.input,
        output: newNeuron,
      ),
    );

    connections.add(
      Connection(
        input: newNeuron,
        output: oldConnection.output,
      ),
    );
  }
}
