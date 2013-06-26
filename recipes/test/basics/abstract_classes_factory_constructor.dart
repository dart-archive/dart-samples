import 'package:unittest/unittest.dart';

abstract class Book {
  // ...
  factory Book() {
    return new _Book();
  }
}

// Default implementation.
class _Book implements Book {}

void main() {
  group('factory constructor', () {
    test('', () {
      var book = new Book();
      expect(book.runtimeType.toString(), equals('_Book'));
      expect(book is Book, isTrue);
      expect(book is _Book, isTrue);
    });
  });
}