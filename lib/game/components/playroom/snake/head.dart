import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

import '../../../../utils/direction.dart';
import '../../../snake_game.dart';
import '../../mixins/playroom_component.dart';
import '../../playroom.dart';
import '../fruit.dart';
import '../snake.dart';
import '../wall.dart';
import 'tail.dart';

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
    } else if (other is Wall || other is TailPart) {
      gameRef.gameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    final angle = switch (parent.direction) {
      Direction.up => 0.0,
      Direction.right => 0.5,
      Direction.down => 1.0,
      Direction.left => 1.5,
      null => 1.5, // Default direction is left
    };

    canvas.save();
    canvas.translate(cellSize / 2, cellSize / 2);
    canvas.rotate(angle * math.pi);
    canvas.translate(-cellSize / 2, -cellSize / 2);
    super.render(canvas);
    canvas.restore();
  }
}
