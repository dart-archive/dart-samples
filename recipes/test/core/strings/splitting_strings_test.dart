library splitting_strings_test;

import 'package:unittest/unittest.dart';

void main() {
  group('splitting a string', () {
    var clef = '\u{1F3BC}';
    var smileyFace = '\u263A';
    var happy = 'I am $smileyFace';

    group('using split(string)', () {
      test('on code-unit boundary', () {
        expect(happy.split(' '), equals(['I', 'am', '☺']));
      });
    });
      
    group('using split(regExp)', () {
      var nums = '2/7 3 4/5 3~/5';
      var numsRegExp = new RegExp(r'(\s|/|~/)');
      test('', () { 
        expect(nums.split(numsRegExp), 
          equals(['2', '7', '3', '4', '5', '3', '5']));
      });
    });
    
    group('using splitMapJoin(regExp)', () {
      expect('Eats SHOOTS leaves'.splitMapJoin((new RegExp(r'SHOOTS')),
          onMatch: (m) => '*${m.group(0).toLowerCase()}*',
          onNonMatch: (n) => n.toUpperCase()
      ), equals('EATS *shoots* LEAVES'));
    });
  });
}
