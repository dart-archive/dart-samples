library testing_string_emptiness_test;

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
    
    test('by checking for equality', () {
      expect('' == 'u\2004', isFalse);
    });
  });  
}

