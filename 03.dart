import 'dart:math';
import 'utils.dart';

void main() {
  const _dx = const [1, 0, -1, 0];
  const _dy = const [0, 1, 0, -1];

  // part 1
  final n = int.parse(read('3.txt').trim());
  var x = 0, y = 0;
  for (var i = 1, j = 0; i < n; j++) {
    final dx = _dx[j % 4], dy = _dy[j % 4];
    int length = ((j - j % 2) >> 1) + 1; // 1 1 2 2 3 3 ...
    length = min(length, n - i);
    x += dx * length;
    y += dy * length;
    i += length;
  }
  final d1 = x.abs() + y.abs();
  print(d1);

  // constant time solution part 1
  // Imagine problem as nested squares. Square surface is the number at the
  // bottom right corner.
  final side = sqrt(n).ceil(); // Side length of square the number is on
  final sq = (side - 1) ~/ 2; // Square index (starting at 0)
  final ps = pow(side - 2, 2); // Largest number in previous square
  final pos1 = n - ps; // Position of n within the square
  final pos2 = pos1 % (side - 1); // Position of n on the side
  final d2 = sq + (pos2 - sq).abs();
  print(d2);

  // part 2
  final grid = new Map<int, Map<int, int>>();
  void allocate(int x, int y) {
    grid.putIfAbsent(x, () => new Map<int, int>());
    grid[x][y] = grid[x][y] ?? 0;
  }

  allocate(0, 0);
  grid[0][0] = 1;

  var gx = 0, gy = 0;
  for (var j = 0;; j++) {
    final dx = _dx[j % 4], dy = _dy[j % 4];
    int length = ((j - j % 2) >> 1) + 1;
    do {
      gx += dx;
      gy += dy;
      var value = 0;
      for (var v = gx - 1; v <= gx + 1; v++) {
        for (var w = gy - 1; w <= gy + 1; w++) {
          allocate(v, w);
          value += grid[v][w];
        }
      }
      grid[gx][gy] = value;

      if (value > n) {
        print(value);
        return;
      }
    } while (--length > 0);
  }
}
