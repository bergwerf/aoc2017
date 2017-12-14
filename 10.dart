import 'utils.dart';

void main() {
  // part 1
  final data = read('10.txt').trim().split(new RegExp(r',\s*')).map(int.parse);
  final n = 256;
  final rope = new List<int>.generate(n, (i) => i);

  var position = 0;
  var skipsize = 0;
  for (final length in data) {
    final copy = rope.toList();
    for (var i = 0; i < length; i++) {
      rope[(position + i) % n] = copy[(position + length - 1 - i) % n];
    }
    position = (position + length + skipsize++) % n;
  }
  print(rope[0] * rope[1]);

  // part 2
  print(knotHashHex(knotHash(read('10.txt').trim())));
}

String knotHashHex(List<int> input) {
  return input.map((i) => i.toRadixString(16).padLeft(2, '0')).join();
}

List<int> knotHash(String input) {
  final n = 256;
  final cycles = 64;
  final seed = [17, 31, 73, 47, 23];
  final lengths = input.codeUnits.toList()..addAll(seed);
  final rope = new List<int>.generate(n, (i) => i);

  var position = 0;
  var skipsize = 0;
  for (var c = 0; c < cycles; c++) {
    for (final length in lengths) {
      final copy = rope.toList();
      for (var i = 0; i < length; i++) {
        rope[(position + i) % n] = copy[(position + length - 1 - i) % n];
      }
      position = (position + length + skipsize++) % n;
    }
  }

  // Convert to sparse hash.
  final sparse = new List<int>();
  for (var i = 0; i < rope.length; i++) {
    if (i % 16 == 0) {
      sparse.add(rope[i]);
    } else {
      sparse[sparse.length - 1] = sparse.last ^ rope[i];
    }
  }

  return sparse;
}
