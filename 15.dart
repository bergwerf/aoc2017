void main() {
  final facA = 16807, facB = 48271;
  final mod = 2147483647, modA = 4, modB = 8;
  //final initA = 65, initB = 8921;
  final initA = 512, initB = 191;
  int prevA, prevB;

  // part 1
  var judge1 = 0;
  prevA = initA;
  prevB = initB;
  for (var i = 0; i < 40000000; i++) {
    prevA = (prevA * facA) % mod;
    prevB = (prevB * facB) % mod;
    if (prevA & 0xffff == prevB & 0xffff) {
      judge1++;
    }
  }
  print(judge1);

  // part 2
  var judge2 = 0;
  prevA = initA;
  prevB = initB;
  for (var i = 0; i < 5000000; i++) {
    do {
      prevA = (prevA * facA) % mod;
    } while (prevA % modA != 0);
    do {
      prevB = (prevB * facB) % mod;
    } while (prevB % modB != 0);

    if (prevA & 0xffff == prevB & 0xffff) {
      judge2++;
    }
  }
  print(judge2);
}
