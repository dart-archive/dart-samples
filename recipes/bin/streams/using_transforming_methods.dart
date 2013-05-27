import 'dart:async';

void main() {
  List data = [1, 2, 3, 4, 5, 6];
  Stream<int> stream  = new Stream.fromIterable(data);
  stream
    .where((int x) => x % 2 == 0) // 2, 4, 6
    .map((int x) => x * 2)        // 4, 8, 12
    .skip(1)                      // 8, 12
    .listen(print);
}