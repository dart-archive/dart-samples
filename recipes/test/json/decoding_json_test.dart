import 'package:unittest/unittest.dart';

import 'dart:json' as json;

main() {
  group('json.parse()', () {
    var jsonPerson = '{"name" : "joe", "date" : [2013, 3, 10]}';
    
    test('simple parse', () {
      var person = json.parse(jsonPerson);
      expect(person['name'], equals('joe'));
      expect(person['date'], equals([2013, 3, 10]));
      expect(person['date'] is List, isTrue);
    });
    
    test('with reviver', () {
      var person = json.parse(jsonPerson, (key, parsedValue) {
        if (key == "date") {
          return new DateTime(2012, 10, 3);
        }
        return parsedValue;
      });
      
      expect(person['name'], equals('joe'));
      expect(person['date'] is DateTime, isTrue);
    });
  });
}