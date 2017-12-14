import '10.dart';

void main() {
  final input = 'jxqlasbh';
  final squares = new List<List<int>>();
  for (var y = 0; y < 128; y++) {
    final row = knotHash('$input-$y');
    for (var x = 0; x < row.length; x++) {
      for (var n = 0; n < 8; n++) {
        if ((row[x] >> (7 - n)) & 1 == 1) {
          squares.add([x * 8 + n, y]);
        }
      }
    }
  }
  print(squares.length);

  // Find regions.
  final regions = new List<Set<int>>();
  final regionMap = new Map<int, int>();
  for (var i = 0; i < squares.length; i++) {
    regions.add([i].toSet());
    regionMap[i] = i;
  }

  for (var i = 0; i < squares.length; i++) {
    for (var j = i + 1; j < squares.length; j++) {
      final a = squares[i], b = squares[j];
      if ((a[0] - b[0]).abs() + (a[1] - b[1]).abs() == 1 &&
          regionMap[i] != regionMap[j]) {
        regions[regionMap[i]].addAll(regions[regionMap[j]]);
        for (final k in regions[regionMap[j]]) {
          regionMap[k] = regionMap[i];
        }
      }
    }
  }
  print(regionMap.values.toSet().length);
}
