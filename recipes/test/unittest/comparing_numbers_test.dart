import 'package:unittest/unittest.dart';
import 'dart:math';

class Point {
  num x, y;
  
  Point(this.x, this.y);
  
  distanceTo(Point other) {
    return sqrt(pow((x - other.x), 2) + pow((y - other.y), 2));
  }
}

void main() {
  Point p1 = new Point(-2, -3);
  Point p2 = new Point(-4, 4);
  print(p1.distanceTo(p2));
  print(2 / 3);
  
  test('distance', () {
    expect(p1.distanceTo(p2), closeTo(7.28, .001)); // 7.280109889280518
  });
}


