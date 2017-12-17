void main() {
  // part 1
  final steps = 382;
  final buffer = [0];
  var position = 0;
  for (var i = 1; i <= 2017; i++) {
    position = (position + steps + 1) % buffer.length;
    buffer.insert(position, i);
  }
  print(buffer[(position + 1) % buffer.length]);

  // part 2
  final fiftyMillion = 50000000;
  var positionOfZero = 0;
  var method1 = 0, method2 = 0;
  var position1 = 0, position2 = 0;
  for (var i = 1; i <= fiftyMillion; i++) {
    position1 = (position1 + steps + 1) % i; // wrap around
    position2 = (position2 + steps) % i + 1; // add offset simulating shift

    // method 1: Shift zero forward when a value is inserted before it.
    if (position1 == (positionOfZero + 1) % i) {
      method1 = i;
    }
    if (position1 <= positionOfZero) {
      positionOfZero++;
    }

    // method 2: Shift zero forward by shifting the position (already done).
    if (position2 == 1) {
      method2 = i;
    }
  }
  print(method1);
  print(method2);
}
