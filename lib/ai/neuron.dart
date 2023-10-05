import '../../utils/math.dart';
import 'connection.dart';

abstract class Neuron {
  late final int id;
  double get value;

  Map<String, dynamic> toJson() => {
        'id': id,
      };
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
  InputNeuron();

  factory InputNeuron.fromJson(Map<String, dynamic> json) {
    return InputNeuron()..id = json['id'] as int;
  }

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
  HiddenNeuron();

  factory HiddenNeuron.fromJson(Map<String, dynamic> json) {
    return HiddenNeuron()..id = json['id'] as int;
  }

  @override
  final List<Connection> inputs = [];
  @override
  final List<Connection> outputs = [];
}

class OutputNeuron extends Neuron with WithInputsNeuronMixin {
  OutputNeuron();

  factory OutputNeuron.fromJson(Map<String, dynamic> json) {
    return OutputNeuron()..id = json['id'] as int;
  }

  @override
  final List<Connection> inputs = [];
}
