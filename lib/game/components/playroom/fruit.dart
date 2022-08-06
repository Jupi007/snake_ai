import 'package:flame_svg/flame_svg.dart';

class Fruit extends SvgComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    svg = await Svg.load('assets/images/fruit.svg');
  }
}
