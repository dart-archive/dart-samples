library calculating_the_length_test;

import 'package:unittest/unittest.dart';

print(obj) {
  return obj;  
}

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
      var clef = '\u{1D11E}';
      expect(clef.length, equals(2));
      expect(clef.runes.length, equals(1));

      var music = 'I $hearts $clef';
      expect(music.length, equals(6));
      expect(music.runes.length, equals(5));
    });
    
    test('that has superimposed characters', () {
      var name = 'Ameli\u00E9';  // 'Amelié'
      var anotherName = 'Ameli\u0065\u0301';  // 'Amelié'
      expect(print(name.length), equals(6));
      expect(print(anotherName.length), equals(7));
    });
  });
}
