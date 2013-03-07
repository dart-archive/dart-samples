library converting_between_string_characters_test;

import 'package:unittest/unittest.dart';


void main() {
  group('converting between string characters and numerical codes', () {
    var smileyFace = '\u263A';
    var clef = '\u{1F3BC}';
    
    group('using runes', () {
      test('', () {
        expect('Dart'.runes.toList(), equals([68, 97, 114, 116]));
        
        expect(smileyFace.runes.toList(), equals([9786]));
        expect(smileyFace.runes.first.toRadixString(16), equals('263a'));

        expect(clef.runes.toList(), equals([127932]));
        expect(clef.runes.first.toRadixString(16), equals('1f3bc'));
      });
    });
    
    group('using codeUnits', () {
      test('', () {
        expect('Dart'.codeUnits.toList(), equals([68, 97, 114, 116]));
        
        expect(smileyFace.codeUnits.toList(), equals([9786]));
        expect(smileyFace.codeUnits.first.toRadixString(16), equals('263a'));

        expect(clef.codeUnits.toList(), equals([55356, 57276]));
        expect(clef.codeUnits.map((codeUnit) => codeUnit.toRadixString(16))
          .toList(), equals(['d83c', 'dfbc']));
      });
    });
    
    group('using codeUnitAt', () {
      test('', () {
        expect('Dart'.codeUnitAt(0), equals(68));
        
        expect(smileyFace.codeUnitAt(0), equals(9786)); // 9786
        expect(smileyFace.codeUnitAt(0).toRadixString(16), equals('263a'));
        
        expect(clef.codeUnitAt(0), equals(55356));
        expect(clef.codeUnitAt(0).toRadixString(16), equals('d83c'));
        expect(clef.codeUnitAt(1), equals(57276));
       expect(clef.codeUnitAt(1).toRadixString(16), equals('dfbc'));
      });
    });
 
    group('using fromCharCodes', () {
      var heart = '\u2661';
      
      test('', () {
        expect(new String.fromCharCodes([68, 97, 114, 116]), equals('Dart'));
        expect(new String.fromCharCodes([73, 32, 9825, 32, 76, 117, 99, 121]),
            equals("I $heart Lucy"));
      });
      
      test('', () {
        expect(new String.fromCharCodes([9786]), equals(smileyFace));
      });
      
      test('with surrogate pair codeUnits', () {
        expect(new String.fromCharCodes([55356, 57276]), equals(clef));
      });
      
      test('with rune', () {
        expect(new String.fromCharCode(127932), equals(clef));
      });
    });
    
    group('using fromCharCode', () {      
      test('', () {
        expect(new String.fromCharCode(68), equals('D'));
        expect(new String.fromCharCode(9786), equals(smileyFace));
        expect(new String.fromCharCode(127932), equals(clef));
      });
    });
  });
}
