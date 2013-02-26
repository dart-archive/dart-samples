library subscripting_strings_test;

import 'package:unittest/unittest.dart';

void main() {
  group('getting the character at a specific index', () {
    group('with non-BMP symbol', () {
      var hearts = '\u2661';
      
      test('with BMP symbols', () {
        expect('Dart'[0], equals('D'));
        expect(hearts[0], equals('\u2661'));
      });      
    });

    group("with non-BMP symbol", () {
      var coffee = '\u{1F375}';
      var doughnuts = '\u{1F369}';
      var healthFood = '$coffee and $doughnuts';
      test('with non-BMP symbol', () {

        // expect(healthFood[0], equals('?'));
        expect(healthFood.slice(0, 2), equals(coffee));
      }); 
      
      test('', () {
        expect(healthFood.runes.first, equals(127861));
        expect(new String.fromCharCode(127861), equals(coffee));
        expect(healthFood.codeUnits.first, equals(55356));
      }); 
    });
  });
}