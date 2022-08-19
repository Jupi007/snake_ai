import 'package:flutter/widgets.dart';

class ScoreProvider extends ChangeNotifier {
  int _score = 0;
  int _bestScore = 0;

  int get score {
    return _score;
  }

  int get bestScore {
    return _bestScore;
  }

  void increaseScore() {
    _score++;
    notifyListeners();
  }

  void resetScore() {
    _bestScore = _score > _bestScore ? _score : _bestScore;
    _score = 0;
    notifyListeners();
  }
}
