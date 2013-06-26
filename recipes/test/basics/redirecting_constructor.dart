import 'package:unittest/unittest.dart';

class Rectangle {
  static const int DEFAULT_SIZE = 4;
  num length, width;

  Rectangle(this.length, this.width);
  Rectangle.square(num side) : this(side, side);
  Rectangle.defaultSize() : this(DEFAULT_SIZE, DEFAULT_SIZE);

  String toString() => '${this.length}, ${this.width}';
}

void main() {
  test('redirecting constructor', () {
    var rect = new Rectangle(3, 4);
    var square = new Rectangle.square(5);
    var defaultRect = new Rectangle.defaultSize();
    expect(rect.toString(), equals('3, 4'));
    expect(square.toString(), equals('5, 5'));
    expect(defaultRect.toString(), equals('4, 4'));
  });
}