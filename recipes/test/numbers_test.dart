library numbers_test;

import 'packages/unittest/unittest.dart';

void main() {
  group('numbers tests', () {
    group('parse.int', () {
      test('parses string and returns and int', () {
        expect(int.parse('231'), equals(231));
      });
  
      test('allows optional +, - prefixes', () {
        expect(int.parse('+231'), equals(231));
        expect(int.parse('-231'), equals(-231));
      });
  
      test('allows a radix', () {
        expect(int.parse('231', radix: 16), equals(561));
        expect(int.parse('F34A', radix: 16), equals(62282));
      });
  
      test('defaults to base 16 if string starts with "0x", "-0x" or "+0x"', () {
        expect(int.parse('0x231'), equals(561));
      });
  
      test('internally handles error', () {
        var defaultInt = 100;
        expect(int.parse('badArg', onError: ((_) => defaultInt)), equals(100));
      });
  
      test('throws FormatException on failure', () {
        expect(() => int.parse('asdf'), throwsFormatException);
      });
    });
  
    group('double.parse', () {
      test('parses source as a double', () {
        expect(double.parse('3.14'), equals(3.14));
      });
  
      test('accepts + - prefixes', () {
        expect(double.parse('+3.14'), equals(3.14));
        expect(double.parse('-3.14'), equals(-3.14));
      });
  
      test('accepts scientific notation', () {
        expect(double.parse('3.14e5'), equals(314000.0));
      });
  
      test('accepts NaN, Infinity, and -Infinity as args', () {
        // expect(double.parse('NaN'), equals(double.NAN));
        expect(double.parse('Infinity'), equals(double.INFINITY));
        expect(double.parse('-Infinity'), equals(double.NEGATIVE_INFINITY));
      });
  
      test('internally handles error', () {
        var defaultDouble = 3.14;
        expect(double.parse('asdf', ((_) => defaultDouble)), equals(3.14));
      });
  
      test('throws FormatException on failure', () {
        expect(() => double.parse('badArg'), throwsFormatException);
      });
    });
  
    test('using toString()', () {
      expect(1234.toString(), equals('1234'));
      expect(3.1519.toString(), equals('3.1519'));
    });
  
    test('convert the number to decimal exponential notation', () {
      expect(1234.toStringAsExponential(), equals('1.234e+3'));
      expect(3.1519.toStringAsExponential(), equals('3.1519e+0'));
  
      // You can specify the digits after the decimal point.
      expect(3.1519.toStringAsExponential(5), equals('3.15190e+0'));
    });
  
    test('convert the number with n digits after the decimal point', () {
      expect(1234.toStringAsFixed(2), equals('1234.00'));
      expect(3.1519.toStringAsFixed(2), equals('3.15'));
    });
  
    test('convert the number with n significant digits', () {
      expect(1234.toStringAsPrecision(5), equals('1234.0'));
      expect(3.1519.toStringAsPrecision(8), equals('3.1519000'));
    });
  
    test('specify radix', () {
      expect(64.toRadixString(2), equals('1000000'));
      expect(64.toRadixString(8), equals('100'));
      expect(64.toRadixString(16), equals('40'));
    });
  });
}
