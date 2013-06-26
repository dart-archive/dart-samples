import 'package:unittest/unittest.dart';

class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);
  const Point.zero() : x = 0, y = 0;

  // Non-const
  Point.fromOther(Point other): x = other.x, y = other.y;
}

main() {
  group('const constructor', () {
    test('using const', () {
      const Point point0 = const Point.zero();
      const Point point1 = const Point(0, 0);
      expect(point0 == point1, isTrue);
      expect(identical(point0, point1), isTrue);
    });

    test('using new', () {
      Point point3 = new Point.zero();
      Point point4 = new Point(0, 0);
      expect(point3 == point4, isFalse);
      // Can't do this. Fields are still final.
      // p3.x = 10;
    });
  });
}
