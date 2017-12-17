import 'dart:math';
import 'utils.dart';

class Vec2 {
  final int x, y;
  Vec2(this.x, this.y);
  Vec2 operator +(Vec2 b) => new Vec2(x + b.x, y + b.y);
}

int hexDistance(Vec2 v) {
  if (v.x.sign == v.y.sign) {
    return (v.x + v.y).abs();
  } else {
    return max(v.x.abs(), v.y.abs());
  }
}

void main() {
  // Using: https://stackoverflow.com/questions/5084801
  final data = read('11.txt').split(',');
  final directions = {
    'n': new Vec2(0, 1),
    'ne': new Vec2(1, 0),
    'se': new Vec2(1, -1),
    's': new Vec2(0, -1),
    'sw': new Vec2(-1, 0),
    'nw': new Vec2(-1, 1),
  };

  var v = new Vec2(0, 0);
  final dist = new List<int>();
  for (final d in data) {
    v += directions[d];
    dist.add(hexDistance(v));
  }

  print(dist.last);
  print(dist.fold(0, max));
}
