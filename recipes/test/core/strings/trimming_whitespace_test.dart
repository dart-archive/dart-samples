library trimming_whitespace_test;

import "package:unittest/unittest.dart";

void main() {
  group('trimming whitespace from a string', () {
    var space = '\n\r\f\t\v';
    var string = '$space X $space';
    
    test('', () {
      expect(string.trim(), equals('X'));
    });

    test('leading whitespace', () {
      expect(string.replaceFirst(new RegExp(r'^\s+'), ''), equals('X $space'));
    });

    test('trailing whitespace', () {
      expect(string.replaceFirst(new RegExp(r'\s+$'), ''), equals('$space X'));
    });
  });  
  
}

