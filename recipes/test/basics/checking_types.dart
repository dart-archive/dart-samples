import 'package:unittest/unittest.dart';

class Animal {}
class Dog extends Animal {}

void main() {
  test('', () {
    var list = new List();
    expect(list is List, isTrue);
    expect(list is Iterable, isTrue);
    expect(list is Object, isTrue);
  });

  test('inheritance', () {
    expect(new Dog() is Animal, isTrue);
  });

}