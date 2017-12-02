import 'utils.dart';

void main() {
  var prev = -1, sum = 0;
  final units = new List<int>.from(read('1.txt').trim().codeUnits);
  for (final c in units..add(units.first)) {
    final n = c - '0'.codeUnitAt(0);
    if (n == prev) {
      sum += n;
    }
    prev = n;
  }
  print(sum);
}
