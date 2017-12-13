import 'dart:math';
import 'utils.dart';

void main() {
  final data = (read('13.txt').trim().split('\n'))
      .map((line) => line.split(': ').map(int.parse).toList());
  final layers = new Map<int, int>.fromIterable(data,
      key: (kv) => kv[0], value: (kv) => kv[1]);
  final maxLayer = layers.keys.fold(0, max);
  var wasCaught = true, delay = -1;
  while (wasCaught) {
    delay++;
    wasCaught = false;
    var i = -1, s = 0;
    while (++i <= maxLayer) {
      final t = delay + i;
      final r = layers.containsKey(i) ? 2 * layers[i] - 2 : null;
      final isCaught = r != null ? t % r == 0 : false;
      s += isCaught ? i * layers[i] : 0;
      wasCaught = wasCaught || isCaught;
    }
    if (delay == 0) {
      print(s);
    }
  }
  print(delay);
}
