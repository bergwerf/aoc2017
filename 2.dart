import 'dart:math';
import 'utils.dart';

void main() {
  final checksum = read('2.txt')
      .trim()
      .split('\n')
      .map((l) => l.split(new RegExp(r'\s')).map(int.parse))
      .map((Iterable<int> l) => l.reduce(max) - l.reduce(min))
      .reduce((a, b) => a + b);
  print(checksum);
}
