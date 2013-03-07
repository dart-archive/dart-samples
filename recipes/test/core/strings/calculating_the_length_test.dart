library calculating_the_length_test;

import 'package:unittest/unittest.dart';

void main() {
  group('calculating the length of a string', () {
    
    var hearts = '\u2661';

    test('that contains only BMP symbols', () {
      expect('I love music'.length, equals(12));
      expect('I love music'.runes.length, equals(12));

      expect(hearts.length, equals(1));
      expect(hearts.runes.length, equals(1));
    });
    
    test('that contains non-BMP symbols', () {
      var clef = '\u{1F3BC}';
      expect(clef.length, equals(2));
      expect(clef.runes.length, equals(1));

      var music = 'I $hearts $clef';
      expect(music.length, equals(6));
      expect(music.runes.length, equals(5));
    });
  });
}
