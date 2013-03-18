library handling_extended_characters_test;

import 'package:unittest/unittest.dart';

print(obj) => obj;

void main() {
  var clef = '\u{1D11E}';
  group('creating an extended character', () {
    test('using a rune', () {
      expect(print(clef), equals('𝄞'));
    });
  });
  
  group('accessing runes and code units', () {
    test('', () {
      expect(clef.codeUnits.map((codeUnit) => codeUnit.toRadixString(16)), equals(['d834', 'dd1e']));
      expect(clef.runes.map((rune) => rune.toRadixString(16)).toList(), equals(['1d11e']));
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
      expect(print(clef.runes.first.toRadixString(16)), equals('1d11e'));
      expect(print(clef.runes.toList()[0].toRadixString(16)), equals('1d11e'));
      // This test will never pass because clef[0] is an illegal string.
      // expect(print(clef[0]), equals('?'));
      expect(print(clef.codeUnits[0]), equals(55348));
      expect(clef.runes.toList()[0], equals(119070));
    });
  });
}

