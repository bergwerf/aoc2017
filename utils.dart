/// Generic utilities
library aoc2017.aoc;

import 'dart:io';

String read(String file) => new File('input/$file').readAsStringSync();
num sum(num a, num b) => a + b;
