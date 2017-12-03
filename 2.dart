import 'dart:math';
import 'utils.dart';

void main() {
  final data = read('2.txt')
      .trim()
      .split('\n')
      .map((l) => l.split(new RegExp(r'\s')).map(int.parse));

  final checksum1 = data
      .map((Iterable<int> l) => l.reduce(max) - l.reduce(min))
      .reduce((a, b) => a + b);

  final checksum2 = data
      .map((Iterable<int> l) {
        final list = l.toList();
        for (var i = 0; i < list.length; i++) {
          for (var j = 0; j < list.length; j++) {
            if (i == j) {
              continue;
            } else {
              final frac = list[i] / list[j];
              if (frac.remainder(1.0) == 0.0) {
                return frac;
              }
            }
          }
        }
        throw new Exception('no pair of integers that evenly divide');
      })
      .reduce((a, b) => a + b)
      .toInt();

  print(checksum1);
  print(checksum2);
}
