library getting_list_of_chars;

import 'package:unittest/unittest.dart';

void main() {
  group('getting a list of characters', () {
    var smileyFace = '\u263A';
    var happy = 'I am $smileyFace';
    var clef = '\u{1F3BC}';
    
    test('on rune boundary', () {
      expect('Dart'.runes.map((rune) => new String.fromCharCode(rune)).toList(), 
          equals(['D', 'a', 'r', 't']));
      
      expect(happy.runes.map((rune) => new String.fromCharCode(rune)).toList(), 
          equals(['I', ' ', 'a', 'm', ' ', '\u263A']));
      
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
