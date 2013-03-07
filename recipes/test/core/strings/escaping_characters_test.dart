library escaping_characters_test;

import 'package:unittest/unittest.dart';

void main() { 
  
  group('escaping characters', () {
    var name = '''Wile
Coyote''';
    
    test('using an escape character', () {
      expect('Wile\nCoyote', equals('''Wile
Coyote'''));
    });
    
    test('using hex notation', () {
      expect('Wile\x0ACoyote', equals('''Wile
Coyote'''));
    });
    
    test('using unicode notation', () {
      expect('Wile\u000ACoyote', equals('''Wile
Coyote'''));
    });
    
    test('with non-special character', () {
      expect('Wile \E Coyote', equals('Wile E Coyote'));
    });
  });
}
