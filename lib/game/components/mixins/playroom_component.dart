import 'package:flame/components.dart';

import '../playroom.dart';
import '../playroom_cell.dart';

mixin PlayroomComponent on PositionComponent {
  final PlayroomCell _cell = PlayroomCell(0, 0);

  int get col {
    return _cell.col;
  }

  set col(int col) {
    assert(row >= 0 && row <= playroomSize);

    _cell.col = col;
    x = col * cellSize;
  }

  int get row {
    return _cell.row;
  }

  set row(int row) {
    assert(row >= 0 && row <= playroomSize);

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
