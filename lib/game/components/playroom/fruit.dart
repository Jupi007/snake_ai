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
    await super.onLoad();

    svg = await Svg.load('images/fruit.svg');
    size = Vector2.all(cellSize);

    cell = PlayroomCell(5, 3);
    //move();

    await add(RectangleHitbox());
  }

  void move() {
    final freeCells = <PlayroomCell>[];

    for (var c = 0; c < playroomSize; c++) {
      for (var r = 0; r < playroomSize; r++) {
        freeCells.add(PlayroomCell(c, r));
      }
    }

    for (final wall in playroomRef.walls) {
      freeCells.removeWhere(
        (element) => element.col == wall.col && element.row == wall.row,
      );
    }

    for (final bodyPart in playroomRef.snake.tail) {
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
