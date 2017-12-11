import 'utils.dart';

void main() {
  final Iterable<Iterable<String>> data =
      read('4.txt').trim().split('\n').map((line) => line.split(' '));
  final validLines1 = data.where((line) => line.toSet().length == line.length);
  print(validLines1.length);

  final validLines2 = validLines1.where((Iterable<String> line) {
    return line.every((word1) => line
        .where((word2) => word1 != word2)
        .every((word2) => !isAnagram(word1, word2)));
  });
  print(validLines2.length);
}

// Check if [b] is an anagram of [a].
bool isAnagram(String a, String b) {
  final counter = new Map<String, int>();
  for (var i = 0; i < a.length; i++) {
    counter[a[i]] = (counter[a[i]] ?? 0) + 1;
  }
  for (var i = 0; i < b.length; i++) {
    counter[b[i]] = (counter[b[i]] ?? 0) - 1;
  }
  return counter.values.every((v) => v == 0);
}
