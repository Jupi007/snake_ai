import '../../utils/math.dart';
import 'neuron.dart';

class Connection {
  Connection({
    required this.input,
    required this.output,
    int? innovation,
    double? weight,
    this.enabled = true,
  }) {
    input.outputs.add(this);
    output.inputs.add(this);

    _innovation = innovation ?? ++innovationCounter;
    this.weight = weight ?? randomDouble(-1.0, 1.0);
  }

  bool enabled;

  static int innovationCounter = 0;
  late final int _innovation;
  int get innovation => _innovation;

  late double weight;

  final WithOutputsNeuron input;
  final WithInputsNeuron output;

  double get value {
    if (!enabled) {
      return 0;
    }

    return input.value * weight;
  }
}
