library getting_the_length_test;

import 'package:unittest/unittest.dart';

void main() {
  group('getting the length of a string', () {
    var clef = '\u{1F3BC}';
    var hearts = '\u2661';
    var music = 'I $hearts $clef';
    
    test('that contains only BMP symbols', () {
      expect('I love music'.length, equals(12));
      expect(hearts.length, equals(1));
      expect(hearts.runes.length, equals(1));
    });
    
    test('that contains non-BMP symbols', () {
      expect(clef.length, equals(2));
      expect(clef.runes.length, equals(1));
      expect(music.length, equals(6));
      expect(music.runes.length, equals(5));
    });
  });
}