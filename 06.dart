import 'dart:math';
import 'utils.dart';

void main() {
  // part 1
  final List<int> data =
      read('6.txt').trim().split(new RegExp(r'\s')).map(int.parse).toList();
  final history = new List<List<int>>();
  while (!history.any((list) => compareLists(list, data))) {
    history.add(data.toList());
    var i = data.indexOf(data.reduce(max));
    var redist = data[i];
    data[i] = 0;
    while (redist-- > 0) {
      data[++i % data.length]++;
    }
  }
  print(history.length);

  // part 2.
  print(history.length -
      history.indexOf(history.singleWhere((list) => compareLists(list, data))));
}
