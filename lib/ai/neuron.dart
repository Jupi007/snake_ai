import 'connection.dart';

class Neuron {
  double value = 0.0;
}

/// A first range neuron which represents a "sense"
class SensoryNeuron extends Neuron {
  SensoryNeuron({required this.outputConnection});

  final Connection outputConnection;
}

/// An intermediary neuron which will makes the network "think"
class RelayNeuron extends Neuron {
  RelayNeuron({
    required this.inputConnection,
    required this.outputConnection,
  });

  final Connection inputConnection;
  final Connection outputConnection;
}

/// A last range neuron which links the network to an "action"
class MotorNeuron extends Neuron {
  MotorNeuron({required this.inputConnection});

  final Connection inputConnection;
}
