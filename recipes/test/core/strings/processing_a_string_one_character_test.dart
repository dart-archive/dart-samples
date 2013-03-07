library processing_a_string_one_character_test;

import 'package:unittest/unittest.dart';

void main() {
  

  group('processing a string one character at a time', () {
    var smileyFace = '\u263A';
    var happy = 'I am $smileyFace';
    var clef = '\u{1F3BC}';
    
    test('on rune boundary', () {
      expect("Dart".runes.map((rune) => '*${new String.fromCharCode(rune)}*').toList(),
          equals(['*D*', '*a*', '*r*', '*t*']));
      
      expect(happy.runes.map((rune) => [rune, new String.fromCharCode(rune)]).toList(), 
          equals([ [73, 'I'], [32, ' '], [97, 'a'], [109, 'm'], [32, ' '], [9786, '☺'] ]));
      
      expect(clef.runes.map((rune) => new String.fromCharCode(rune)).toList(), 
          equals(['\u{1F3BC}']));
    });

    test('on code-unit boundary', () {
      expect('Dart'.split(''), equals(['D', 'a', 'r', 't']));
      expect(smileyFace.split('').length, equals(1));
      expect(clef.split('').length, equals(2));
    });
  });
}
