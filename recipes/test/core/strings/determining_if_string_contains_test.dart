library determining_if_string_contains_test;

import 'package:unittest/unittest.dart';

void main() {
  
  group('determining whether a string contains a substring', () {
    var string = 'Dart strings are immutable';
    
    test('using contains', () {
      expect(string.contains('immutable'), isTrue);
      expect(string.contains('Dart', 2), isFalse);
    });
    
    test('using startsWith()', () {
      expect(string.startsWith('Dart'), isTrue);
    });
    
    test('using endsWith()', () {
      assert(string.endsWith('e') == true);
    });
    
    test('using indexOf()', () {
      expect(string.indexOf('art') != -1, isTrue);
    });
    
    test('using hasMatch()', () {
      expect(new RegExp(r'ar[et]').hasMatch(string), isTrue);
    });
  });

}
