library changing_string_case_test;

import 'package:unittest/unittest.dart';

void main() {
group('changing string case', () {
    var theOneILove = 'I love Lucy!';

    test('with toUpperCase()', () {
      expect(theOneILove.toUpperCase(), equals('I LOVE LUCY!'));
    });
    
    test('with toLowerCase()', () {
      expect(theOneILove.toLowerCase(), equals('i love lucy!'));
    });
    
    test('with bicameral characters', () {
      var zeus = '\u0394\u03af\u03b1\u03c2'; // Δίας
      var resume = '\u0052\u00e9\u0073\u0075\u006d\u00e9'; // Résumé
      expect(zeus.toLowerCase(), equals('δίας'));
      expect(zeus.toUpperCase(), equals('ΔΊΑΣ'));
      expect(resume.toLowerCase(), equals('résumé'));
      expect(resume.toUpperCase(), equals('RÉSUMÉ'));
    });

    test('with unicameral characters', () {
      var chickenKebab = '\u091a\u093f\u0915\u0928 \u0915\u092c\u093e\u092c'; 
      // चिकन कबाब
      expect(chickenKebab.toLowerCase(), equals(chickenKebab));
      expect(chickenKebab.toUpperCase(), equals(chickenKebab));
    });
  });
}

