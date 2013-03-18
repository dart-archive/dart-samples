library processing_a_string_one_character_test;

import 'package:unittest/unittest.dart';

print(obj) {
  return obj;
}

void main() {
  
  group('processing a string one character at a time', () {
    var clef = '\u{1D11E}';
    var lang= 'Dart';
    
    group('using split', () {
      test('on code-unit boundary', () {
        expect(lang.split('').map((char) => '*${char}*').toList(),
            equals(['*D*', '*a*', '*r*', '*t*']));
        
        var smileyFace = '\u263A';
        var happy = 'I am $smileyFace';
        expect(print(happy.split('')), equals(['I', ' ', 'a', 'm', ' ', '☺']));
        expect(clef.split('').length, equals(2));
      });
    });
    
    group('indexing the string in a loop', () {
      test('', () {
        var list = [];
        for(var i = 0; i < lang.length; i++) {
          list.add('*${lang[i]}*'); 
        }
        expect(list, equals(['*D*', '*a*', '*r*', '*t*']));      
      });
      
      test('with an extended character', () {
        var list = [];
        for(var i = 0; i < clef.length; i++) {
          list.add([clef[i], clef[i].runes.first]); 
        }
        // Because we are dealing with invalid strings, this test can never pass.
        // expect(print(list.last), equals([[?, 55348], [?, 56606]]));
      });
    });

    group('mapping runes', () {
      test('', () {
        expect(lang.runes.map((rune) => '*${new String.fromCharCode(rune)}*').toList(),
            equals(['*D*', '*a*', '*r*', '*t*']));
        
        var smileyFace = '\u263A';
        var happy = 'I am $smileyFace';
        expect(happy.runes.map((rune) => [rune, new String.fromCharCode(rune)]).toList(), 
            equals([ [73, 'I'], [32, ' '], [97, 'a'], [109, 'm'], [32, ' '], [9786, '☺'] ]));
        
        var subject = '$clef list:';
        expect(subject.runes.map((rune) => new String.fromCharCode(rune)).toList(), 
            equals(['𝄞', ' ', 'l', 'i', 's', 't', ':']));
      });
    });
  });
}
