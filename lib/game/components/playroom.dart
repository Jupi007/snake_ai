import 'package:flame/components.dart';

import 'playroom/fruit.dart';
import 'playroom/snake.dart';
import 'playroom/wall.dart';

const playroomSize = 15;

class Playroom extends Component {
  late Fruit fruit;
  late List<Wall> walls;
  late Snake snake;
}
