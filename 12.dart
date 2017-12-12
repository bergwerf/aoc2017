import 'utils.dart';

void main() {
  final List<List<int>> data = (read('12.txt').trim().split('\n'))
      .map((line) => (line.split(' ')..removeAt(1))
          .map((str) => int.parse(str.replaceAll(',', '')))
          .toList())
      .toList();

  final groups = new List<Set<int>>();
  final groupIndex = new Map<int, int>();
  for (var i = 0; i < data.length; i++) {
    final pid = data[i].first;
    groups.add([pid].toSet());
    groupIndex[pid] = groups.length - 1;
  }

  for (var i = 0; i < data.length; i++) {
    final pid = data[i].first;
    final connections = data[i].sublist(1);
    for (final c in connections) {
      if (groupIndex[pid] != groupIndex[c]) {
        groups[groupIndex[pid]].addAll(groups[groupIndex[c]]);
        for (final j in groups[groupIndex[c]]) {
          groupIndex[j] = groupIndex[pid];
        }
      }
    }
  }

  final filteredGroups = groupIndex.values.toSet().map((i) => groups[i]);
  final zeroGroup = filteredGroups.singleWhere((g) => g.contains(0));
  print(zeroGroup.length);
  print(filteredGroups.length);
}
