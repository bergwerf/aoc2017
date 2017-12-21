import 'utils.dart';

void main() {
  final List<List<List<String>>> data = read('21.txt')
      .split('\n')
      .map((l) => l.split(' => ').map((p) => p.split('/').toList()).toList())
      .toList();

  final enhancements = new Map<String, List<String>>();
  for (final enhancement in data) {
    // Rotate 4 ways.
    var key = enhancement[0];
    for (var i = 0; i < 4; i++) {
      key = rotate(key);

      // Flip in 4 ways.
      enhancements[key.join('/')] = enhancement[1];
      enhancements[flipv(key).join('/')] = enhancement[1];
      enhancements[fliph(key).join('/')] = enhancement[1];
      enhancements[flipv(fliph(key)).join('/')] = enhancement[1];
    }
  }

  final picture = <String>[
    '.#.', //
    '..#', //
    '###'
  ];

  for (var i = 1; i <= 18; i++) {
    final tmp = new List<String>();

    // Separate into parts.
    final size = picture.length;
    final partSize = size % 2 == 0 ? 2 : 3;
    for (var py = 0; py + partSize <= picture.length; py += partSize) {
      // Add partSize + 1 lines to tmp.
      for (var i = 0; i < partSize + 1; i++) {
        tmp.add('');
      }

      for (var px = 0; px + partSize <= picture.first.length; px += partSize) {
        // Extract pattern.
        final pattern = new List<String>();
        for (var y = py; y < py + partSize; y++) {
          pattern.add(picture[y].substring(px, px + partSize));
        }

        // Apply enhancement.
        final enh = enhancements[pattern.join('/')];
        for (var y = 0; y < enh.length; y++) {
          final _y = tmp.length - enh.length + y;
          tmp[_y] = '${tmp[_y]}${enh[y]}';
        }
      }
    }

    picture.clear();
    picture.addAll(tmp);

    if ([5, 18].contains(i)) {
      print(picture.map((l) => l.replaceAll('.', '').length).fold(0, sum));
    }
  }
}

/// Rotate the given square [picture].
List<String> rotate(List<String> picture) {
  final out = new List<String>();
  for (var i = 1; i <= picture.length; i++) {
    out.add(picture.map((line) => line[picture.length - i]).join());
  }
  return out;
}

List<String> flipv(List<String> picture) {
  return picture
      .map((line) => new String.fromCharCodes(line.codeUnits.reversed))
      .toList();
}

List<String> fliph(List<String> picture) {
  return picture.reversed.toList();
}
