import 'utils.dart';

void main() {
  final units = read('1.txt').trim().codeUnits;
  var prev = units.last, sum = 0;
  for (final unit in units) {
    if (unit == prev) {
      sum += unit - '0'.codeUnitAt(0);
    }
    prev = unit;
  }
  print(sum);
}
