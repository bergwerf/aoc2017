import 'utils.dart';

void main() {
  final List<List<List<int>>> data = read('20.txt')
      .split('\n')
      .map((l) => l.split(', ').map((v3) {
            return v3
                .substring(3, v3.length - 1)
                .split(',')
                .map(int.parse)
                .toList();
          }).toList())
      .toList();
  final activeParticles = new List<int>.generate(data.length, (i) => i);

  for (var t = 1; t < 100; t++) {
    for (var _i = 0; _i < activeParticles.length; _i++) {
      final i = activeParticles[_i];
      final p = data[i][0], v = data[i][1], a = data[i][2];
      for (var d = 0; d < 3; d++) {
        v[d] += a[d];
        p[d] += v[d];
      }
    }

    final removeQueue = new List<int>();

    FIRST:
    for (var _i = 0; _i < activeParticles.length; _i++) {
      final p1 = data[activeParticles[_i]][0];
      SECOND:
      for (var _j = _i + 1; _j < activeParticles.length; _j++) {
        final p2 = data[activeParticles[_j]][0];
        for (var d = 0; d < 3; d++) {
          if (p1[d] != p2[d]) {
            continue SECOND;
          }
        }
        removeQueue.add(_i);
        removeQueue.add(_j);
      }
    }

    final unique = removeQueue.toSet().toList();
    unique.sort();
    unique.reversed.forEach(activeParticles.removeAt);
  }

  print(activeParticles.length);

  // Attempt to use analysis (failed)
  /*for (var i = 0; i < data.length; i++) {
    for (var j = i + 1; j < data.length; j++) {
      // If i and j will ever collide, add them to the willCollide set.
      // https://www.desmos.com/calculator/qfrbaqfere
      // v(t) = v_s + t*a
      // x(t) = x_s + t*(v_s + t*a/2) = (a/2)*t^2 + v_s*t + x_s
      // x1(t) = x2(t)
      // (a1/2)*t^2 + v1_s*t + x1_s - ((a2/2)*t^2 + v2_s*t + x2_s) = 0
      // (a1/2 - a2/2)*t^2 + (v1_s - v2_s)*t + (x1_s - x2_s) = 0
      // D = b^2 - 4ac
      // t = (-b +- sqrt(D)) / 2a
      final _1 = data[i], _2 = data[j];
      final p1 = _1[0], v1 = _1[1], a1 = _1[2];
      final p2 = _2[0], v2 = _2[1], a2 = _2[2];

      List<num> findIntersect(int d) {
        final a = a1[d] / 2 - a2[d] / 2;
        final b = v1[d] - v2[d];
        final c = p1[d] - p2[d];
        final D = pow(b, 2) - 4 * a * c;
        if (a != 0 && D >= 0) {
          final t1 = (-b + sqrt(D)) / (2 * a);
          final t2 = (-b - sqrt(D)) / (2 * a);
          return [t1, t2].map((t) => t.round()).toList();
        } else {
          return [];
        }
      }

      num distance(int d, num t) {
        final x1 = p1[d] + t * (v1[d] + t * a1[d] / 2);
        final x2 = p2[d] + t * (v2[d] + t * a2[d] / 2);
        return (x1 - x2).abs();
      }

      // Compute intersections.
      final ix = findIntersect(0);
      final iy = findIntersect(1);
      final iz = findIntersect(2);

      // Find timeslot that matches.
      // Only consider discrete intersections at t > 0.
      final tset = ix
          .toSet()
          .intersection(iy.toSet())
          .intersection(iz.toSet())
          .where((t) => t > 0);
    }
  }*/
}
