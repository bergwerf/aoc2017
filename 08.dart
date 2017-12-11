import 'dart:math';
import 'utils.dart';

void main() {
  final data = read('8.txt').trim().split('\n').map((l) => l.split(' '));
  final registers = new Map<String, int>();
  final process = {
    '>': (a, b) => a > b,
    '<': (a, b) => a < b,
    '==': (a, b) => a == b,
    '!=': (a, b) => a != b,
    '>=': (a, b) => a >= b,
    '<=': (a, b) => a <= b
  };

  int get(String key) {
    registers.putIfAbsent(key, () => 0);
    return registers[key];
  }

  var maxx = 0;
  for (final ins in data) {
    final v = int.parse(ins[2]);
    final add = ins[1] == 'inc' ? v : -v;
    if (process[ins[5]](get(ins[4]), int.parse(ins[6]))) {
      get(ins[0]);
      registers[ins[0]] += add;
      if (registers[ins[0]] > maxx) {
        maxx = registers[ins[0]];
      }
    }
  }

  print(registers.values.fold(0, max));
  print(maxx);
}
