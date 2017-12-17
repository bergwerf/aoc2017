import 'utils.dart';

void main() {
  final input = read('01.txt');
  print(solve(input, 1));
  print(solve(input, input.length ~/ 2));
}

int solve(String input, int delta) {
  assert(!delta.isNegative);
  var sum = 0;
  final units = input.codeUnits;
  for (var i = 0; i < units.length; i++) {
    var j = i + delta;
    j = j >= units.length ? j - units.length : j;
    if (units[i] == units[j]) {
      sum += units[i] - '0'.codeUnitAt(0);
    }
  }
  return sum;
}
