library determining_if_string_is_empty_test;

import 'package:unittest/unittest.dart';

void main() {
  group('determining if string is empty', () {
    test('using isEmpty', () {
      expect(''.isEmpty, isTrue);
    });
    
    test('using ==', () {
      var string = "asdf";
      expect(string == "", equals(false));
    });
   
    test('if string contains a space', () {
      var space = ' ';
      expect(space.isEmpty, isFalse);
    });
  });  
}

