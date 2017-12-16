/// Generic utilities
library aoc2017.aoc;

import 'dart:io';

String read(String file) => new File('input/$file').readAsStringSync();

num sum(num a, num b) => a + b;

bool compareLists(List a, List b) {
  for (var i = 0; i < a.length; i++) {
    if (b.length <= i || a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
