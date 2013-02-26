library finding_regexp_matches;

import 'package:unittest/unittest.dart';

void main() {
  group('finding regExp matches', () {
    var string = 'Not with a fox, not in a box';
    var regExp = new RegExp(r'[fb]ox');
    
    test('using allMatches()', () {
      List matches = regExp.allMatches(string);
      expect(matches.map((match) => match.group(0)).toList(), equals(['fox', 'box'])); 
      // Finding the number of occurences of a substring.
      expect(matches.length, equals(2));
    });

    test('using firstMatch()', () {
      expect(regExp.firstMatch(string).group(0), equals('fox'));
    });
  });
}

