import 'dart:math';
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

  // Using analysis
  //
  // This first didn't work because the way acceleration is summed does not
  // behave in a continuous manner (because of the discrete steps the particles
  // accelerate slower). I didn't consider this and thus wasted several hours
  // trying to debug this.
  //
  // t=0 (p, v, a)
  // t=1 (p+v+a, v+a, a)
  // t=2 (p+v+a+v+a+a, v+a+a, a) == (p+2v+3a, v+2a, a)
  // t=3 (p+v+a+v+a+a+v+a+a+a, v+a+a+a, a) == (p+3v+6a, v+3a, a)
  // t=4 (p+v+a+v+a+a+v+a+a+a+v+a+a+a+a, v+a+a+a+a, a) == (p+4v+10a, v+4a, a)
  //
  // x(t) = p + t*v + (t*(t+1)/2)*a
  //      = p + t*v + ((t*t+t)/2)*a
  //      = p + t*v + (t*t/2)*a + (t/2)*a
  //      = p + t*v + t*(a/2) + t*t*(a/2)
  //      = p + t*(v + a/2) + t*t*(a/2)
  final collisions = new List<List<int>>(); // (t, i, j)
  for (var i = 0; i < data.length; i++) {
    for (var j = i + 1; j < data.length; j++) {
      // To instpect: https://www.desmos.com/calculator/qfrbaqfere
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
        final a = (a1[d] - a2[d]) / 2;
        final b = (v1[d] + a1[d] / 2) - (v2[d] + a2[d] / 2);
        final c = p1[d] - p2[d];
        final D = b * b - 4 * a * c;

        if (b == 0) {
          return [];
        } else if (a == 0) {
          return [-c / b];
        } else if (D >= 0) {
          final t1 = (-b + sqrt(D)) / (2 * a);
          final t2 = (-b - sqrt(D)) / (2 * a);
          return [t1, t2];
        } else {
          return [];
        }
      }

      bool doIntersect(int d, int t) {
        final x1 = p1[d] + t * (v1[d] + a1[d] / 2) + t * t * (a1[d] / 2);
        final x2 = p2[d] + t * (v2[d] + a2[d] / 2) + t * t * (a2[d] / 2);
        return x1 == x2;
      }

      // Compute intersections.
      // 57 and 58 collide at t = 10
      final ix = findIntersect(0)
          .map((t) => t.round())
          .where((t) => doIntersect(0, t));
      final iy = findIntersect(1)
          .map((t) => t.round())
          .where((t) => doIntersect(1, t));
      final iz = findIntersect(2)
          .map((t) => t.round())
          .where((t) => doIntersect(2, t));

      // Find timeslot that matches.
      // Only consider discrete intersections at t > 0.
      final tset = ix
          .toSet()
          .intersection(iy.toSet())
          .intersection(iz.toSet())
          .where((t) => t >= 0);
      if (tset.isNotEmpty) {
        final t = tset.first;
        collisions.add([t, i, j]);
      }
    }
  }

  // Find out how many particles are left.
  collisions.sort((a, b) => a[0] - b[0]);
  final activeParticles = new List<int>.generate(data.length, (i) => i).toSet();
  final removeQueue = new Set<int>();
  for (var i = 0; i < collisions.length; i++) {
    final c = collisions[i];
    if (activeParticles.contains(c[1]) && activeParticles.contains(c[2])) {
      removeQueue..add(c[1])..add(c[2]);
    }
    if (i == collisions.length - 1 || c[0] != collisions[i + 1][0]) {
      activeParticles.removeWhere((p) => removeQueue.contains(p));
      removeQueue.clear();
    }
  }

  // Brute force to check.
  final bruteForced = bruteForce(data);

  print(activeParticles.length);
  print(bruteForced.length);
}

Set<int> bruteForce(List<List<List<int>>> data) {
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

  return activeParticles.toSet();
}
