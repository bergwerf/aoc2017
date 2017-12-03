import 'dart:math';
import 'utils.dart';

void main() {
  final n = int.parse(read('3.txt').trim());
  var x = 0, y = 0;
  for (var i = 1, j = 0; i < n; j++) {
    const _dx = const [1, 0, -1, 0];
    const _dy = const [0, 1, 0, -1];
    final dx = _dx[j % 4], dy = _dy[j % 4];
    int length = ((j - j % 2) >> 1) + 1; // 1 1 2 2 3 3 ...
    length = min(length, n - i);
    x += dx * length;
    y += dy * length;
    i += length;
  }
  final d = x.abs() + y.abs();
  print(d);
}
