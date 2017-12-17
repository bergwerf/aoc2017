import 'utils.dart';

class Disc {
  final String name;
  final int weight;
  final Set<String> children;

  Disc(this.name, this.weight, this.children);
}

void main() {
  // Read data.
  final List<Disc> data = read('07.txt').split('\n').map((line) {
    final info = new RegExp(r'([a-z]+)\s\(([0-9]+)\)').firstMatch(line);
    final name = info.group(1);
    final weight = int.parse(info.group(2));
    final c = new Set<String>();
    if (line.length > info.group(0).length) {
      c.addAll(line.substring(info.group(0).length + 4).trim().split(', '));
    }
    return new Disc(name, weight, c);
  }).toList();

  // Quick lookup (optional).
  final discIndex = new Map<String, Disc>();
  for (final disc in data) {
    discIndex[disc.name] = disc;
  }

  // Find parent.
  var parent = data.first.name;
  for (final disc in data) {
    if (!data.any((d) => d.children.contains(disc.name))) {
      parent = disc.name;
      break;
    }
  }
  print(parent);

  // Find wrong weight.
  final p = discIndex[parent];
  final adjustWeight = findWeight(p, discIndex, computeWeight(p, discIndex));
  print(adjustWeight);
}

int computeWeight(Disc disc, Map<String, Disc> discIndex) {
  return disc.weight +
      (disc.children.map((c) => computeWeight(discIndex[c], discIndex)))
          .fold(0, sum);
}

int findWeight(Disc disc, Map<String, Disc> discIndex, int expect) {
  final children = disc.children.map((c) => discIndex[c]).toList();
  final weights = children.map((c) => computeWeight(c, discIndex)).toList();
  final allTheSame = weights.every((w1) => weights.every((w2) => w1 == w2));

  // If all weights are the same and there is no expectation, check all.
  if (allTheSame) {
    if (expect != disc.weight + weights.reduce(sum)) {
      return expect - weights.reduce(sum);
    } else {
      final expct = (expect - disc.weight) ~/ children.length;
      final output = children.map((c) => findWeight(c, discIndex, expct));
      final filtered = output.where((v) => v != null).toList();

      if (filtered.length > 1) {
        throw new Error();
      } else {
        return filtered.isNotEmpty ? filtered.single : null;
      }
    }
  } else {
    // Find odd one out and try to find the right weight.
    if (children.length == 2) {
      final o1 = findWeight(children[0], discIndex, weights[1]);
      final o2 = findWeight(children[1], discIndex, weights[0]);
      return o1 != null ? o1 : o2;
    } else {
      final copy = weights.toList()..sort();
      final diff = copy[0] == copy[1] ? copy.last : copy.first;
      final same = copy[0] == copy[1] ? copy.first : copy.last;
      final i = weights.indexOf(diff);
      return findWeight(children[i], discIndex, same);
    }
  }
}
