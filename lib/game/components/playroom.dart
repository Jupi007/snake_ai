import 'package:flame/components.dart';

import 'playroom_cell.dart';
import 'playroom/fruit.dart';
import 'playroom/snake.dart';
import 'playroom/wall.dart';

const playroomSize = 15;
const cellSize = 24.0;

class Playroom extends Component {
  List<Wall> walls = [];
  late Fruit fruit;
  late Snake snake;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    for (var i = 0; i < playroomSize - 1; i++) {
      walls.add(Wall()..cell = PlayroomCell(i, 0)); // Top
      walls.add(Wall()..cell = PlayroomCell(playroomSize - 1, i)); // Right
      walls.add(Wall()..cell = PlayroomCell(i + 1, playroomSize - 1)); // Bottom
      walls.add(Wall()..cell = PlayroomCell(0, i + 1)); // Left
    }
    addAll(walls);

    fruit = Fruit()..cell = PlayroomCell(3, 3);
    add(fruit);

    snake = Snake();
    add(snake);
  }
}
