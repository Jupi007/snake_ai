import 'package:flame/components.dart';

import '../../../utils/direction.dart';
import '../../snake_game.dart';
import '../playroom.dart';
import '../playroom_cell.dart';
import 'snake/head.dart';
import 'snake/tail.dart';

class Snake extends Component with HasGameRef<SnakeGame>, ParentIsA<Playroom> {
  late Head head;
  List<TailPart> tail = [];

  bool hasEatenFruit = false;
  Direction? direction;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // The second is hidden behind the first one
    // So the next body part is already loaded (no blink)
    tail.add(TailPart()..cell = PlayroomCell(8, 7));
    tail.add(TailPart()..cell = PlayroomCell(8, 7));
    await addAll(tail);

    head = Head()..cell = PlayroomCell(7, 7);
    await add(head);
  }

  @override
  void update(double dt) {
    game.onBeforeUpdate.broadcast();
    _updateDirection();
    _updateBodyPartsCell();
    _updateHeadCell();
  }

  void _updateDirection() {
    if (!Direction.isOpposite(direction, game.events.direction)) {
      direction = game.events.direction;
    }
  }

  void _updateBodyPartsCell() {
    if (direction != null) {
      for (var i = tail.length - 1; i >= 0; i--) {
        if (hasEatenFruit && i == tail.length - 1) {
          final nextBodyPart = TailPart()..cell = tail[i].cell;

          tail.add(nextBodyPart);
          add(nextBodyPart);

          hasEatenFruit = false;
        }

        if (i == 0) {
          // If first part, move to head cell
          tail[i].cell = head.cell;
        } else {
          if (i == tail.length - 1) {
            // If last part, move to head cell or part cell - 2
            tail[i].cell = i - 2 == -1 ? head.cell : tail[i - 2].cell;
          } else {
            // Else move part to next one
            tail[i].cell = tail[i - 1].cell;
          }
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
}
