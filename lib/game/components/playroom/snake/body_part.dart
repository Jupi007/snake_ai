import 'package:flame_svg/flame_svg.dart';

class BodyPart extends SvgComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    svg = await Svg.load('assets/images/body_part.svg');
  }
}
