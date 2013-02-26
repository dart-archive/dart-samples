library strings_test;

import 'package:unittest/unittest.dart';

import 'concatenating_strings_test.dart' as concatenating_strings_test;
import 'interpolating_expressions_test.dart' as interpolating_expressions_test; 
import 'incrementally_building_test.dart' as incrementally_building_test;
import 'converting_chars_nums_test.dart' as converting_chars_nums_test;
import 'testing_string_emptiness_test.dart' as testing_string_emptiness_test;
import 'trimming_whitespace_test.dart' as trimming_whitespace_test;
import 'getting_the_length_test.dart' as getting_the_length_test;
import 'subscripting_strings_test.dart' as subscripting_strings_test;
import 'splitting_strings_test.dart' as splitting_strings_test;
import 'changing_string_case.dart' as changing_string_case;
import 'determining_if_string_contains_test.dart' as determining_if_string_contains_test;

void main() {
  concatenating_strings_test.main();
  interpolating_expressions_test.main();
  incrementally_building_test.main();
  converting_chars_nums_test.main();
  testing_string_emptiness_test.main;
  trimming_whitespace_test.main();
  getting_the_length_test.main();
  subscripting_strings_test.main();
  splitting_strings_test.main();
  changing_string_case.main();
  determining_if_string_contains_test.main();
  
  group('finding occurences of a string inside another string', () {
    var string = 'Not with a fox, not in a box';
    var regExp = new RegExp(r'[fb]ox');
    
    test('using allMatches()', () {
      List matches = regExp.allMatches(string);
      expect(matches.map((match) => match.group(0)).toList(), equals(['fox', 'box'])); 
      // Finding the number of occurences of a substring.
      expect(matches.length, equals(2));
    });

    test('using firstMatch()', () {
      expect(regExp.firstMatch(string).group(0), equals('fox'));
    });
  });
  
  group('substituting strings based on regExp matches', () {
    var names = 'Seth Mary/Mem Tim=Timmy';
    var namesRegExp = new RegExp(r'(\s|/|=)');
    
    test('using replaceAll()', () {
      expect('resume'.replaceAll(new RegExp(r'e'), '\u00E9'), equals('résumé'));
    });
    
    test('using replaceAllMapped()', () {
      expect(names.replaceAllMapped(namesRegExp, (_) => ' | '), 
          equals('Seth | Mary | Mem | Tim | Timmy'));
    });
    
    test('using replaceFirst()', () {
      expect('0.0001'.replaceFirst(new RegExp(r'0+'), ''), equals('.0001'));
    });
  });
}