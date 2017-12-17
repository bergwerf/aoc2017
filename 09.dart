import 'utils.dart';

void main() {
  final data = read('09.txt').codeUnits;
  final ignore = '!'.codeUnitAt(0);
  final groupOpen = '{'.codeUnitAt(0);
  final groupClose = '}'.codeUnitAt(0);
  final garbageOpen = '<'.codeUnitAt(0);
  final garbageClose = '>'.codeUnitAt(0);

  var sum = 0;
  var depth = 0;
  var inGarbage = false;
  var garbageSum = 0;
  for (var i = 0; i < data.length; i++) {
    final char = data[i];

    // Count garbage.
    if (inGarbage && char != garbageClose && char != ignore) {
      garbageSum++;
    }

    // Unfortunately a switch is not possible without creating const values.
    if (char == ignore) {
      i++;
    } else if (char == groupOpen && !inGarbage) {
      depth++;
    } else if (char == groupClose && !inGarbage) {
      sum += depth;
      depth--;
    } else if (char == garbageOpen) {
      inGarbage = true;
    } else if (char == garbageClose) {
      inGarbage = false;
    }
  }

  print(sum);
  print(garbageSum);
}
