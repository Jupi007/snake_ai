import 'package:flame/components.dart';

import '../playroom.dart';
import '../playroom_cell.dart';

mixin PlayroomCellComponent on PositionComponent {
  final PlayroomCell _cell = PlayroomCell(0, 0);

  Playroom? _playroomRef;

  Playroom get playroomRef {
    if (_playroomRef == null) {
      var c = parent;
      while (c != null) {
        if (c is Playroom) {
          _playroomRef = c;
          return c;
        } else {
          c = c.parent;
        }
      }
      throw StateError('Cannot find Playroom reference in the component tree');
    }
    return _playroomRef!;
  }

  int get col {
    return _cell.col;
  }

  set col(int col) {
    assert(col >= 0 && col < playroomSize);

    _cell.col = col;
    x = col * cellSize;
  }

  int get row {
    return _cell.row;
  }

  set row(int row) {
    assert(row >= 0 && row < playroomSize);

    _cell.row = row;
    y = row * cellSize;
  }

  PlayroomCell get cell {
    return _cell;
  }

  set cell(PlayroomCell cell) {
    // Use setter to pass asserts
    col = cell.col;
    row = cell.row;
  }
}
