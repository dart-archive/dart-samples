import 'dart:json' as json;
import 'package:unittest/unittest.dart';

class Person {
  String name;
  num age;
  
  Person(this.name, this.age);
  String toJson() => json.stringify({"name": name, "age": age});
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
                  'aliases': null
                 };
    
    test('simple', () {
      expect(json.stringify(person) == '{"name":"joe","born":2002,"into":{"films":["crime","noir"]},"aliases":null}', isTrue);
    });
    
    test('with object with a toJson() defined', () {
      var person = new Person('john', 32);
      // JSON only deals with double quotes.
      expect(json.stringify(person), equals(r'"{\"name\":\"john\",\"age\":32}"'));
    });
    
    test('with object lacking toJson()', () {
      var person = new Person('john', 32);
      var book = new Book('War and Peace', 1089);
      var object = {'person': person, 'reads' : book};
      
      expect(() => json.stringify(book), 
          throwsA(predicate((e) => e is json.JsonUnsupportedObjectError)));
      
      try {
        json.stringify(object);
        throw "managed to stringify an object without a toJson()";
      } catch(e) {
          expect(e.cause.toString().startsWith(
              "Class 'Book' has no instance method 'toJson'."), isTrue);
      }
    });
  });  
}