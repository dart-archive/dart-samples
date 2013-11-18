library json_test;

import 'dart:convert' show JSON;
import 'package:unittest/unittest.dart';

class Person {
  String name;
  num age;

  Person(this.name, this.age);
  dynamic toJson() => {"name": name, "age": age};
}

class Book {
  String title;
  num numPages;

  Book(this.title, this.numPages);
}

main() {
  group('test stringify()', () {
    var person = {'name': 'joe',
                  'born':  2002,
                  'into': {'films' : ['crime', 'noir']},
                  'aliases': []};

    test('simple', () {
      expect(JSON.encode(person) == '{"name":"joe","born":2002,"into":{"films":["crime","noir"]},"aliases":[]}', isTrue);
    });

    test('with object with a toJson() defined', () {
      var person = new Person('john', 32);
      // JSON only deals with double quotes.
      expect(JSON.encode(person), equals('{"name":"john","age":32}'));
    });

    test('with object lacking toJson()', () {
      var person = new Person('john', 32);
      var book = new Book('War and Peace', 1089);
      var object = {'person': person, 'reads' : book};

      expect(() => JSON.encode(book), throws);
    
      try {
        JSON.encode(object);
        throw "managed to stringify an object without a toJson()";
      } catch(e) {
        expect(e.cause.toString().startsWith(
          "Class 'Book' has no instance method 'toJson'."), isTrue);
      }
    });
  });


  group('JSON.decode()', () {

    var jsonPerson = '{"name" : "joe", "date" : [2013, 3, 10]}';

    test('simple parse', () {
      var person = JSON.decode(jsonPerson);
      expect(person['name'], equals('joe'));
      expect(person['date'], equals([2013, 3, 10]));
      expect(person['date'] is List, isTrue);
    });

    test('with reviver', () {
      var person = JSON.decode(jsonPerson, reviver: (key, value) {
        if (key == "date") {
          return new DateTime(value[0], value[1], value[2]);
        }
        return value;
      });

      expect(person['name'], equals('joe'));
      expect(person['date'] is DateTime, isTrue);
    });
  });
}
