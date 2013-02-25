library converting_chars_nums_test;

import 'package:unittest/unittest.dart';


void main() {
  group('converting between string characters and numerical codes', () {
    var smileyFace = '\u263A';
    var clef = '\u{1F3BC}';
    
    group('using runes', () {
      test('', () {
        expect('Dart'.runes.toList(), equals([68, 97, 114, 116]));
        
        var codePoints = smileyFace.runes.toList(); // [9786]
        expect(codePoints.first.toRadixString(16), equals('263a'));
        
        codePoints = clef.runes.toList(); // [127932]
        expect(codePoints.first.toRadixString(16), equals('1f3bc'));
      });
    });
    
    group('using codeUnits', () {
      test('', () {
        expect('Dart'.codeUnits.toList(), equals([68, 97, 114, 116]));

        var codeUnits = smileyFace.codeUnits.toList(); // [9786]
        expect(codeUnits.first.toRadixString(16), equals('263a'));
        
        codeUnits = clef.codeUnits.toList(); // [55356, 57276]
        expect(codeUnits.map((codeUnit) => codeUnit.toRadixString(16)).toList(), equals(['d83c', 'dfbc']));
      });
    });
    
    group('using codeUnitAt', () {
      test('', () {
        expect('Dart'.codeUnitAt(0), equals(68));
        
        var codeUnit = smileyFace.codeUnitAt(0); // 9786
        expect(codeUnit.toRadixString(16), equals('263a'));
        
        codeUnit = clef.codeUnitAt(0); // 55356
        expect(codeUnit.toRadixString(16), equals('d83c'));
        
        codeUnit = clef.codeUnitAt(1); // 57276
        expect(codeUnit.toRadixString(16), equals('dfbc'));
      });
    });
 
    group('using fromCharCodes', () {
      var heart = '\u2661';
      
      test('', () {
        expect(new String.fromCharCodes([68, 97, 114, 116]), equals('Dart'));
        expect(new String.fromCharCodes([73, 32, 9825, 32, 76, 117, 99, 121]),
            equals("I $heart Lucy"));
      });
      
      var smileyFace = '\u263A';
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
  });
}