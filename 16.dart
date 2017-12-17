import 'utils.dart';

void main() {
  final data = read('16.txt').split(',');
  final programs = new List<int>.generate(16, (i) => i);

  void swap(int a, int b) {
    int pA = programs[a];
    programs[a] = programs[b];
    programs[b] = pA;
  }

  final seen = new List<List<int>>();
  while (!seen.any((p) => compareLists(p, programs))) {
    seen.add(programs.toList());
    for (final move in data) {
      if (move[0] == 's') {
        final spin = int.parse(move.substring(1)) % programs.length;
        final tail = programs.sublist(programs.length - spin);
        programs.removeRange(programs.length - spin, programs.length);
        programs.insertAll(0, tail);
      } else if (move[0] == 'x') {
        final values = move.substring(1).split('/').map(int.parse).toList();
        swap(values[0], values[1]);
      } else if (move[0] == 'p') {
        final values = (move.substring(1).split('/'))
            .map((c) => c.codeUnitAt(0) - aAscii)
            .toList();
        swap(programs.indexOf(values[0]), programs.indexOf(values[1]));
      }
    }
  }

  printPrograms(seen[1]);

  // Find cycle.
  final start = seen.indexOf(seen.firstWhere((p) => compareLists(p, programs)));
  final at1bln = (1000000000 - start) % (seen.length - start);
  printPrograms(seen[at1bln]);
}

final aAscii = 'a'.codeUnitAt(0);
void printPrograms(List<int> programs) {
  print(new String.fromCharCodes(programs.map((p) => p + aAscii)));
}
