library determining_if_string_is_empty_test;

import 'package:unittest/unittest.dart';

void main() {
  var emptyString = '';
  group('determining if string is empty', () {
    test('using isEmpty', () {
      expect(emptyString.isEmpty, isTrue);
    });

    test('using isNotEmpty', () {
      expect(emptyString.isNotEmpty, isFalse);
    });

    test('using ==', () {
      var string = "asdf";
      expect(string == emptyString, isFalse);
    });

    test('if string contains a space', () {
      var space = ' ';
      expect(space.isEmpty, isFalse);
    });
  });
}

