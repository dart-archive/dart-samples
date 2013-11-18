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
      var person = json.parse(jsonPerson, (key, value) {
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