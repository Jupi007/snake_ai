import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

import '../../../snake_game.dart';
import '../../mixins/playroom_component.dart';
import '../../playroom.dart';
import '../fruit.dart';
import '../snake.dart';
import '../wall.dart';
import 'body_part.dart';

class Head extends SvgComponent
    with
        CollisionCallbacks,
        ParentIsA<Snake>,
        HasGameRef<SnakeGame>,
        PlayroomCellComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    svg = await Svg.load('images/head.svg');
    size = Vector2.all(cellSize);

    await add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other.position != position) {
      return;
    }

    if (other is Fruit) {
      parent.hasEatenFruit = true;
      gameRef.increaseScore();
      other.move();
    } else if (other is Wall || other is BodyPart) {
      gameRef.gameOver();
    }
  }
}
