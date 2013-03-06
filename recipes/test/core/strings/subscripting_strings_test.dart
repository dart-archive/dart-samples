library subscripting_strings_test;

import 'package:unittest/unittest.dart';

void main() {
  group('getting the character at a specific index', () {
    group("with non-BMP symbol", () {
      test('with non-BMP symbol', () {
        var coffee = '\u{1F375}';
        expect(coffee.runes.toList(), equals([127861]));
        expect(new String.fromCharCode(coffee.runes.first),
          equals(coffee));
        // Cannot use coffee[0] directly.
        expect(coffee.codeUnits.first, equals(55356));
        expect(coffee.codeUnits.toList()[0], equals(55356));
      }); 
    });

    group('with BMP symbol', () {
      
      test('with BMP symbols', () {
        expect('Dart'[0], equals('D'));

        var hearts = '\u2661';
        expect(hearts[0], equals('\u2661'));
      });      
    });
  });
}
