library calculating_the_length_test;

import 'package:unittest/unittest.dart';

print(obj) => obj;

void main() {
  var clef = '\u{1F3BC}';
  group('creating an extended character', () {
    test('using a rune', () {
      expect(print(clef), equals('🎼'));
    });
  });
  
  group('accessing runes and code units', () {
    test('', () {
      expect(clef.codeUnits.map((codeUnit) => codeUnit.toRadixString(16)), equals(['d83c', 'dfbc']));
      expect(clef.runes.map((rune) => rune.toRadixString(16)).toList(), equals(['1f3bc']));
    });
  });
  
  group('accessing length', () {
    test('', () {
      expect(print(clef.length), equals(2));
      expect(print(clef.codeUnits.length), equals(2));
      expect(print(clef.runes.length), equals(1));
    });
  });
  
  group('subscripting', () {
    test('', () {
      expect(print(clef.runes.first.toRadixString(16)), equals('1f3bc'));
    });
  });
}

