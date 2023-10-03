import 'dart:math' as math;

int randomInt([
  int min = 0,
  int max = 1,
]) {
  return min + math.Random().nextInt(max + 1 - min);
}

double randomDouble([
  double min = 0.0,
  double max = 1.0,
]) {
  return min + math.Random().nextDouble() * (max - min);
}

double centredRandomDouble([
  double min = 0.0,
  double max = 1.0,
]) {
  var rand = 0.0;

  for (var i = 0; i < 6; i += 1) {
    rand += randomDouble(min, max);
  }

  return rand / 6;
}

double sigmoid(double x) {
  return 1 / (1 + math.exp(-x));
}
