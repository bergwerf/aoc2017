import 'utils.dart';

void main() {
  final data = read('22.txt').split('\n').toList();
  final input = new Set<int>();

  // Read infected fields.
  final size = data.length;
  final half = (size / 2).floor();
  for (var _x = 0; _x < size; _x++) {
    for (var _y = 0; _y < size; _y++) {
      if (data[_y][_x] == '#') {
        input.add(coord(_x - half, half - _y));
      }
    }
  }

  print(compute(input, 10000, 0)); // part 1
  print(compute(input, 10000000, 1)); // part 2
}

//enum NodeState { clean, weakened, infected, flagged }
const stateCount = 4;
const stateInfected = 2;

int compute(Set<int> input, int iterations, int evolution) {
  var direction = 0; // 0-3: up, right, down, left
  var x = 0, y = 0;

  // Run iterations.
  var infectionCount = 0;
  final nodes = new Map<int, int>();
  for (final c in input) {
    nodes[c] = stateInfected;
  }

  for (var i = 0; i < iterations; i++) {
    final c = coord(x, y);
    if (i % 10000 == 0) {
      print(i / iterations);
    }
    switch (evolution) {
      case 0:
        final wasInfected = nodes.remove(c) == stateInfected;
        direction = (direction + (wasInfected ? 1 : -1)) % 4;
        if (!wasInfected) {
          infectionCount++;
          nodes[c] = stateInfected;
        }
        break;

      case 1:
        final state = nodes[c] ?? 0;
        final turn = state - 1;
        direction = (direction + turn) % 4;
        final newState = (state + 1) % stateCount;
        nodes[c] = newState;

        if (newState == stateInfected) {
          infectionCount++;
        }
        break;
    }

    // Move forward.
    x += mod(2 - direction, 2);
    y += mod(1 - direction, 2);
  }

  return infectionCount;
}

/// Compute hash for the given ([x]; [y]) coordinate.
/// This function has a LOT of influence on the performance of the HashMap.
int coord(int x, int y) {
  return ((x << 12) & 0xfff000) | (y & 0xfff);
}

/// Modulo that preserves sign.
int mod(int x, int y) {
  return x < 0 ? -(x % y) : x % y;
}
