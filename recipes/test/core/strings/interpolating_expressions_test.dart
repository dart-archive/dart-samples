library interpolating_expressions_test;

import 'package:unittest/unittest.dart';

class Point {
  num x, y;
  Point(this.x, this.y);
}

class PointWithToString {
  num x, y;
  PointWithToString(this.x, this.y);
  
  String toString() => 'x: $x, y: $y';
}

void main() {
  group('interpolating expressions', () {
    test('without {}', () {
      var favFood = 'sushi';
      expect('I love ${favFood.toUpperCase()}', equals('I love SUSHI')); 
      expect('I love $favFood', equals('I love sushi'));
    });
    
    test('with implicit toString()', () {
      var four = 4;
      expect('The $four seasons', equals('The 4 seasons'));
      expect('The '.concat(4.toString()).concat(' seasons'), equals('The 4 seasons'));
       
      var point = new Point(3, 4);
      expect('Point: $point', equals("Point: Instance of 'Point'"));
    });
    
    test('with explicit toString()', () {
      var point = new PointWithToString(3, 4);
      expect('Point: $point', equals('Point: x: 3, y: 4'));
      
    });
  });
}
