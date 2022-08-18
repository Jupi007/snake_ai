import 'package:flame/components.dart';

import '../../direction.dart';
import '../../snake_game.dart';
import '../playroom.dart';
import '../playroom_cell.dart';
import 'snake/body_part.dart';
import 'snake/head.dart';

class Snake extends Component with HasGameRef<SnakeGame>, ParentIsA<Playroom> {
  late Head head;
  List<BodyPart> bodyParts = [];

  bool hasEatenFruit = false;
  Direction? direction;

  DateTime _time = DateTime.now();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    bodyParts.add(BodyPart()..cell = PlayroomCell(6, 5));
    addAll(bodyParts);

    head = Head()..cell = PlayroomCell(5, 5);
    add(head);
  }

  @override
  void update(double dt) {
    if (!_canUpdate()) {
      return;
    }

    _updateDirection();
    _updateBodyPartsCell();
    _updateHeadCell();
  }

  void _updateDirection() {
    if (!Direction.isOpposite(direction, gameRef.events.direction)) {
      direction = gameRef.events.direction;
    }
  }

  void _updateBodyPartsCell() {
    if (direction != null) {
      for (int i = bodyParts.length - 1; i >= 0; i--) {
        if (hasEatenFruit && i == bodyParts.length - 1) {
          final bodyPart = BodyPart()..cell = bodyParts[i].cell;

          bodyParts.add(bodyPart);
          add(bodyPart);

          hasEatenFruit = false;
        }

        if (i == 0) {
          bodyParts[i].cell = head.cell;
        } else {
          bodyParts[i].cell = bodyParts[i - 1].cell;
        }
      }
    }
  }

  void _updateHeadCell() {
    if (direction == Direction.up) {
      head.row -= 1;
    } else if (direction == Direction.right) {
      head.col += 1;
    } else if (direction == Direction.down) {
      head.row += 1;
    } else if (direction == Direction.left) {
      head.col -= 1;
    }
  }

  bool _canUpdate() {
    final expectedNextUpdate = _time.add(const Duration(milliseconds: 100));

    if (expectedNextUpdate.isBefore(DateTime.now())) {
      _time = expectedNextUpdate;
      return true;
    }

    return false;
  }
}
