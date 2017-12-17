import 'utils.dart';

void main() {
  // part 1
  final data = read('05.txt').split('\n').map(int.parse).toList();
  final data1 = data.toList();
  var ptr = 0, counter = 0;
  while (ptr >= 0 && ptr < data1.length) {
    counter++;
    ptr += data1[ptr]++;
  }
  print(counter);

  // part 2
  final data2 = data.toList();
  ptr = 0;
  counter = 0;
  while (ptr >= 0 && ptr < data2.length) {
    counter++;
    ptr += data2[ptr] >= 3 ? data2[ptr]-- : data2[ptr]++;
  }
  print(counter);
}
