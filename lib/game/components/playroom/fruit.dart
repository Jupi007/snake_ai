import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';

import '../mixins/playroom_component.dart';
import '../playroom.dart';

class Fruit extends SvgComponent with PlayroomComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    svg = await Svg.load('images/fruit.svg');
    size = Vector2.all(cellSize);

    add(RectangleHitbox());
  }
}
