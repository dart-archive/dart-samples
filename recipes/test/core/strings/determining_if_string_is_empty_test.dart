library determining_if_string_is_empty_test;

import 'package:unittest/unittest.dart';

void main() {
  group('determining if string is empty', () {
    var emptyString = '';
    var space = ' ';
    
    test('', () {
      expect(emptyString.isEmpty, isTrue);
    });
    
    test('if string contains a space', () {
      expect(space.isEmpty, isFalse);
    });
  });  
}

