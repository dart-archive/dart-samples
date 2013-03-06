library substituting_strings_test;

import 'package:unittest/unittest.dart';

void main() {
  group('substituting strings based on regExp matches', () {
    test('using replaceAll()', () {
      expect('resume'.replaceAll(new RegExp(r'e'), '\u00E9'), equals('résumé'));
    });
    
    test('using replaceFirst()', () {
      expect('0.0001'.replaceFirst(new RegExp(r'0+'), ''), equals('.0001'));
    });

    test('using replaceAllMapped()', () {
      var heart = '\u2661';
      var string = "I like Ike but I $heart Lucy";
      var regExp = new RegExp(r'[A-Z]\w+');
      expect(string.replaceAllMapped(
        regExp, (match) => match.group(0).toUpperCase()), 
        equals('I like IKE but I ♡ LUCY'));
    });
    
  });
}
