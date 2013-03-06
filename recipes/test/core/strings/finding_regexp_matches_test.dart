library finding_regexp_matches;

import 'package:unittest/unittest.dart';

void main() {
  group('finding regExp matches', () {
    var neverEatingThat = 'Not with a fox, not in a box';
    var regExp = new RegExp(r'[fb]ox');
    
    test('using allMatches()', () {
      List matches = regExp.allMatches(neverEatingThat);
      expect(matches.map((match) => match.group(0)).toList(), equals(['fox', 'box'])); 
      // Finding the number of occurences of a subneverEatingThat.
      expect(matches.length, equals(2));
    });

    test('using firstMatch()', () {
      expect(regExp.firstMatch(neverEatingThat).group(0), equals('fox'));
    });
    
    test('using neverEatingThatMatch', () {
      expect(regExp.stringMatch(neverEatingThat), equals('fox'));
      expect(regExp.stringMatch('I like bagels and lox'), isNull);
    });
  });
}

