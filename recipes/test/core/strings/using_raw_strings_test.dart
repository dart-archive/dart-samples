library using_raw_strings_test;

import 'package:unittest/unittest.dart';

print(obj) => obj;

void main() {
  group("using raw string", () {
    test('escaping special characters', () {
      var subsetSymbol = '\u2282';
      expect('A ⊂ B can be written as ' + r'A \u2282 B', equals(
          'A ⊂ B can be written as A \\u2282 B'));

      expect(print(r'Wile \E Coyote'), equals(r'Wile \E Coyote'));
      
      var superGenius = 'Wile Coyote';                                                     
      expect(print(r'$superGenius and Road Runner'), equals(r'$superGenius and Road Runner'));               
    });
    
    test('escaping interpolation', () {
      expect('A ⊂ B can be written as ' + r'A $subsetSymbol B', equals(
          'A ⊂ B can be written as A \$subsetSymbol B'));
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
