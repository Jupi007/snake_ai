import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

import '../../mixins/playroom_component.dart';
import '../../playroom.dart';

class TailPart extends SvgComponent with PlayroomCellComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    svg = await Svg.load('images/tail.svg');
    size = Vector2.all(cellSize);

    await add(RectangleHitbox());
  }
}
