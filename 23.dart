import 'utils.dart';
import '18.dart';

void main() {
  final List<List<String>> data = read('23.txt')
      .split('\n')
      .map((l) =>
          l.replaceFirst(new RegExp(r'\s*\#.*\n'), '').split(' ').toList())
      .toList();
  final mem = new Map<String, int>();

  // part 1
  mem.clear();
  var multiplyCount = 0;
  for (var i = 0; i < data.length;) {
    if (data[i][0] == 'mul') {
      multiplyCount++;
    }
    final state = process(mem, data[i], [], [], i, 3);
    i = state.pointer;
    if (state.paused) {
      break;
    }
  }
  print(multiplyCount);

  // part 2
  var compositeCount = 0;
  for (var _b = 93 * 100 + 100000, i = 0; i <= 1000; i++) {
    var b = _b + 17 * i;
    // This is an integer factorization problem: if b can be factorized (i.e. is
    // not a prime), then h is incremented.
    for (var f1 = 2; f1 < b; f1++) {
      if (b % f1 == 0) {
        // Is a composite number.
        compositeCount++;
        break;
      }
    }
  }
  print(compositeCount);
}
