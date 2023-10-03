import '../../utils/math.dart';
import 'connection.dart';

abstract class Neuron {
  late final int id;
  double get value;
}

abstract interface class WithInputsNeuron extends Neuron {
  List<Connection> get inputs;
}

abstract interface class WithOutputsNeuron extends Neuron {
  List<Connection> get outputs;
}

mixin WithInputsNeuronMixin on Neuron implements WithInputsNeuron {
  @override
  List<Connection> get inputs;

  @override
  double get value {
    var value = 0.0;

    for (final input in inputs) {
      value = value + input.value;
    }

    return sigmoid(value);
  }
}

class InputNeuron extends Neuron implements WithOutputsNeuron {
  @override
  final List<Connection> outputs = [];

  double? _value;

  @override
  double get value => _value!;
  set value(double? value) => _value = value;
}

class HiddenNeuron extends Neuron
    with WithInputsNeuronMixin
    implements WithOutputsNeuron {
  @override
  final List<Connection> inputs = [];
  @override
  final List<Connection> outputs = [];
}

class OutputNeuron extends Neuron with WithInputsNeuronMixin {
  @override
  final List<Connection> inputs = [];
}
