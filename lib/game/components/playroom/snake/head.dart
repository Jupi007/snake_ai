import 'package:flame_svg/flame_svg.dart';

class Head extends SvgComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    svg = await Svg.load('assets/images/head.svg');
  }
}
