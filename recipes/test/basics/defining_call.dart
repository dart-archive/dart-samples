import 'package:unittest/unittest.dart';

class Point {
  double x, y;
  Point(this.x, this.y);
}

class Counter {
  int value;
  Counter([this.value = 0]);
  call() => value++;
}

class Accumulator {
  int value = 0;
  Accumulator (this.value);

  call(int x) => value += x;
}


void main() {
  var c = new Counter();
  print(c());  // 10
  print(c());  // 11

  var accum = new Accumulator(3);
  print(accum(10)); // 13
  print(accum(5));  // 18
  test('', () {
    expect(() => new Point(3.0, 4.0)(), throws);
  });
}