import 'package:flame/components.dart';

import 'snake/body_part.dart';
import 'snake/head.dart';

class Snake extends Component {
  late Head head;
  late List<BodyPart> bodyParts;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    head = Head();
    add(head);

    final bodyPart = BodyPart();
    bodyParts.add(bodyPart);
    add(bodyPart);
  }
}
