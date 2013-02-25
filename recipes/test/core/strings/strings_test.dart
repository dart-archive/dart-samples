library strings_test;

import 'package:unittest/unittest.dart';

import 'concatenating_strings_test.dart' as concatenating_strings_test;
import 'interpolating_expressions_test.dart' as interpolating_expressions_test; 
import 'incrementally_building_test.dart' as incrementally_building_test;
import 'converting_chars_nums_test.dart' as converting_chars_nums_test;
import 'testing_string_emptiness_test.dart' as testing_string_emptiness_test;

void main() { 
  concatenating_strings_test.main();
  interpolating_expressions_test.main();
  incrementally_building_test.main();
  converting_chars_nums_test.main();
  testing_string_emptiness_test.main;
  
  // TODO: write tests using different unicode space symbols
  group('trimming whitespace from a string', () {
    var x = '  x  ';
    
    test('', () {
      expect(x.trim(), equals('x'));
    });

    test('leading whitespace', () {
      expect(x.replaceFirst(new RegExp(r'^\s+'), ''), equals('x  '));
    });

    test('trailing whitespace', () {
      expect(x.replaceFirst(new RegExp(r'\s+$'), ''), equals('  x'));
    });
  });
  
  group('getting the length of a string', () {
    var clef = '\u{1F3BC}';
    var hearts = '\u2661';
    var music = 'I $hearts $clef'; // length of 4 or 6
    
//    print(music.length); //  Defaults.codeUnit.
//    print(music.runes.length); // You probably want runes.
//    print(music.codeUnits.length); // Same as default.

    test('', () {
      expect('Dart'.length, equals(4));
    });
    
    test('which contains non-BMP symbols', () {
      expect(clef.length, equals(2));
      expect(clef.runes.length, equals(1));
    });
  });

  group('subscripting a string that may contain non-BMP symbols', () {
    var hearts = '\u2661';
    var coffee = '\u{1F375}';
    var doughnuts = '\u{1F369}';
    var healthFood = '$coffee and $doughnuts';
    test('', () {
      expect('Dart'[0], equals('D'));
      expect(hearts[0], equals('\u2661'));
    });
    
    test('with non-BMP symbol', () {
      var code = 127861;
      expect(healthFood.runes.first, equals(code));
      expect(healthFood.runes.toList()[2], equals(97));
      expect(new String.fromCharCode(code), equals('\u{1f375}')); // prints the coffee symbol
    });    
    // food[0] is not valid. It is half of a surrogate pair.
  });
  
  group('splitting a string', () {
    var doughnuts = '\u{1F369}';
    var smileyFace = '\u263A';
    var happy = 'I am $smileyFace';
    group('using split(string)', () {
      test('on code-unit boundary', () {
        expect('Dart'.split(''), equals(['D', 'a', 'r', 't']));
        expect(smileyFace.split('').length, equals(1));
        expect(doughnuts.split('').length, equals(2));
      });
      
      test('on rune boundary', () {
        expect(happy.runes.map((charCode) => new String.fromCharCode(charCode)).last, 
            equals(smileyFace));
      });
    });
      
    group('using split(regExp)', () {
      var names = 'Seth Mary/Mem Tim=Timmy';
      var namesRegExp = new RegExp(r'(\s|/|=)');
      test('', () {
        expect(names.split(namesRegExp), 
            equals(['Seth', 'Mary', 'Mem', 'Tim', 'Timmy']));        
      });
    });
    
    group('using splitMapJoin(regExp)', () {
      expect('Eats SHOOTS leaves'.splitMapJoin((new RegExp(r'SHOOTS')),
          onMatch: (m) => m.group(0).toLowerCase(),
          onNonMatch: (n) => n.toUpperCase()
      ), equals('EATS shoots LEAVES'));
    });
  });
  
  group('changing the case of a string', () {
    var string = 'Rohan loves trains';
    var hearts = '\u2661';
    var stringWithSymbol = 'Rohan $hearts trains';
    
    test('with toUpperCase()', () {
      expect(string.toUpperCase(), equals('ROHAN LOVES TRAINS'));
    });
    
    test('with toLowerCase()', () {
      expect(string.toLowerCase(), equals('rohan loves trains'));
    });
    
    test('when using symbols', () {
      expect(stringWithSymbol.toUpperCase(), equals('ROHAN $hearts TRAINS'));
      expect(stringWithSymbol.toLowerCase(), equals('rohan $hearts trains'));
    });
  });
  
  group('determining whether a string contains a substring', () {
    var string = 'Dart strings are immutable';
    
    test('using contains', () {
      expect(string.contains('immutable'), isTrue);
      expect(string.contains('Dart', 2), isFalse);
    });
    
    test('using startsWith()', () {
      expect(string.startsWith('Dart'), isTrue);
    });
    
    test('using endsWith()', () {
      assert(string.endsWith('e') == true);
    });
  
    test('using indexOf()', () {
      expect(string.indexOf('art') != -1, isTrue);
    });
    
    test('using hasMatch()', () {
      expect(new RegExp(r'ar[et]').hasMatch(string), isTrue);
    });
  });

  group('finding occurences of a string inside another string', () {
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
  
  group('substituting strings based on regExp matches', () {
    var names = 'Seth Mary/Mem Tim=Timmy';
    var namesRegExp = new RegExp(r'(\s|/|=)');
    
    test('using replaceAll()', () {
      expect('resume'.replaceAll(new RegExp(r'e'), '\u00E9'), equals('résumé'));
    });
    
    test('using replaceAllMapped()', () {
      expect(names.replaceAllMapped(namesRegExp, (_) => ' | '), 
          equals('Seth | Mary | Mem | Tim | Timmy'));
    });
    
    test('using replaceFirst()', () {
      expect('0.0001'.replaceFirst(new RegExp(r'0+'), ''), equals('.0001'));
    });
  });
}