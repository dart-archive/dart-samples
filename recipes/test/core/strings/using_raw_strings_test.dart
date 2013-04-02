library using_raw_strings_test;

import 'package:unittest/unittest.dart';

print(obj) => obj;

void main() {
  group("using raw string", () {
    test('escaping special characters', () {
      var subset = '\u2282';
      expect('A ⊂ B can be written as ' + r'A \u2282 B', equals(
          'A ⊂ B can be written as A \\u2282 B'));
    });
    
    test('escaping interpolation', () {
      expect('A ⊂ B can be written as ' + r'A $subset B', equals(
          'A ⊂ B can be written as A \$subset B'));
    });
    
    group('in a regExp', () {
      var nums = '+10, 30, -4';
      var regExp = new RegExp('(\\+|-)?\\d+');
      var rawStringRegExp = new RegExp(r'(\+|-)?\d+');
      
      var matches = regExp.allMatches(nums);
      expect(print(matches.map((match) => match.group(0)).toList()), 
          equals(['+10', '30', '-4']));
  
      matches = rawStringRegExp.allMatches(nums);
      expect(print(matches.map((match) => match.group(0)).toList()), 
          equals(['+10', '30', '-4']));
    });
  });
}