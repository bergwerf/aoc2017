import 'utils.dart';

void main() {
  // The input is embedded in whitespaces.
  final data = read('19.txt', trim: false).split('\n').toList();
  final path = new List<String>();
  var x = data.first.indexOf('|'), y = 0, dx = 0, dy = 1; // start moving down
  var steps = 1;

  WALK:
  while ((dx ?? dy) != null) {
    // Move forward along dx and dy.
    steps++;
    x += dx;
    y += dy;

    // Check if the point has a letter.
    if (!['|', '-', '+'].contains(data[y][x])) {
      path.add(data[y][x]);
    }

    // Check if we can continue.
    if (data[y + dy][x + dx] == ' ') {
      // Find new direction.
      for (var i = 0; i < 4; i++) {
        final _dx = [1, -1, 0, 0][i];
        final _dy = [0, 0, 1, -1][i];
        if (_dx != -dx && _dy != -dy && data[y + _dy][x + _dx] != ' ') {
          dx = _dx;
          dy = _dy;
          continue WALK;
        }
      }

      dx = null;
      dy = null;
    }
  }

  print(path.join());
  print(steps);
}
