library determining_if_string_contains_test;

import 'package:unittest/unittest.dart';

void main() {
  
  group('determining whether a string contains a substring', () {
    var fact = 'Dart strings are immutable';
    
    test('using contains', () {
      expect(fact.contains('immutable'), isTrue);
      expect(fact.contains('Dart', 2), isFalse);
    });
    
    test('using startsWith()', () {
      expect(fact.startsWith('Dart'), isTrue);
    });
    
    test('using endsWith()', () {
      assert(fact.endsWith('e') == true);
    });
    
    test('using indexOf()', () {
      expect(fact.indexOf('art') != -1, isTrue);
    });
    
    test('using hasMatch()', () {
      expect(new RegExp(r'ar[et]').hasMatch(fact), isTrue);
    });
  });

}
