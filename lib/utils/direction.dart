enum Direction {
  up,
  right,
  down,
  left;

  static bool isOpposite(Direction? direction1, Direction? direction2) {
    return direction1 == Direction.up && direction2 == Direction.down ||
        direction1 == Direction.down && direction2 == Direction.up ||
        direction1 == Direction.right && direction2 == Direction.left ||
        direction1 == Direction.left && direction2 == Direction.right;
  }
}
