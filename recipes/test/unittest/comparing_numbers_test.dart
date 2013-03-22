import 'package:unittest/unittest.dart';
import 'dart:math';

class Point {
  num x, y;
  
  Point(this.x, this.y);
  
  distanceTo(Point other) {
    return sqrt(pow((x - other.x), 2) + pow((y - other.y), 2));
  }
}

num distance(point1, point2) {
  return sqrt(pow((point1.x - point2.x), 2) + pow((point1.y - point2.y), 2));
}

void main() {
  Point point1 = new Point(-2, -3);
  Point point2 = new Point(-4, 4);

  test('distance', () {
    expect(distance(new Point(-2, -3), new Point(-4, 4)), 
        closeTo(7.28, .001)); // 7.280109889280518
  });
}


