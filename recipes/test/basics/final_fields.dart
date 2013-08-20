import 'package:unittest/unittest.dart';


class Book {
  final String ISBN;
  Book(String ISBN) : ISBN = ISBN;
}

class Tool {
  final String brand;
  Tool([brand = 'Makita']) : brand = brand;
}

class Person {
  String name;
  int age;
  final Address address;
  Person(this.name, this.age, this.address);
}

class Address {
  String city, state;
  Address(this.city, this.state);
}


void main() {
  group('', () {
    test('', () {
      var book = new Book("99921-58-10-7");
      expect(book.ISBN, equals("99921-58-10-7"));
    });

    test('with default', () {
      var tool = new Tool();
      expect(tool.brand, equals('Makita'));
    });

    test('without using default value', () {
      var tool2 = new Tool('Craftsman');
      expect(tool2.brand, equals('Craftsman'));
    });

    test('final and mutable object', () {
      Person person = new Person('Rohan', 13, new Address('Boston', 'MA'));
      person.address.city = 'Berkeley';
      expect(person.address.city, equals('Berkeley'));
      expect(() => person.address = new Address('New York', 'NY'), throws);
    });
  });
}