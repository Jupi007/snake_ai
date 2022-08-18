import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

import '../mixins/playroom_component.dart';
import '../playroom.dart';
import '../playroom_cell.dart';

class Fruit extends SvgComponent
    with CollisionCallbacks, PlayroomCellComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    svg = await Svg.load('images/fruit.svg');
    size = Vector2.all(cellSize);

    add(RectangleHitbox());
  }

  void move() {
    List<PlayroomCell> freeCells = [];

    for (var c = 0; c < playroomSize; c++) {
      for (var r = 0; r < playroomSize; r++) {
        freeCells.add(PlayroomCell(c, r));
      }
    }

    for (var wall in playroomRef.walls) {
      freeCells.removeWhere(
        (element) => element.col == wall.col && element.row == wall.row,
      );
    }

    for (var bodyPart in playroomRef.snake.bodyParts) {
      freeCells.removeWhere(
        (element) => element.col == bodyPart.col && element.row == bodyPart.row,
      );
    }

    freeCells.removeWhere(
      (element) =>
          element.col == playroomRef.snake.head.col &&
          element.row == playroomRef.snake.head.row,
    );

    cell = (freeCells..shuffle()).first;
  }
}
