import 'neuron.dart';

/// A connexion between two [Neuron]
class Connection {
  Connection({
    required this.inputNeuron,
    required this.outputNeuron,
  });

  final Neuron inputNeuron;
  final Neuron outputNeuron;
}
