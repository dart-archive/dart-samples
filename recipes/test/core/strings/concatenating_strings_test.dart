library concatenating_strings_test;

import 'package:unittest/unittest.dart';

void main() { 
  group('concatenating strings', () {
    group('using adjacent string literals', () {
      var string = 'Dart is fun!';
      
      test('on one line', () {
        expect('Dart' ' is' ' fun!', equals(string));
      });
      
      test('over many lines', () {
        expect('Dart' 
            ' is' 
            ' fun!', equals(string));
      });
      
      test('over one or many lines', () {
        expect('Dart' ' is' 
            ' fun!', equals(string));
      });
      
      test('using multiline strings', () {
        expect('''Peanut
butter '''
'''and
jelly''', equals('Peanut\nbutter and\njelly'));
      });
        
      test('combining single and multiline string', () {
        expect('Peanut ' 'butter'
            ''' and
jelly''', equals('Peanut butter and\njelly'));
      });
    });
  
    group('using alternatives to string literals', () {
      var string = "Dewey Cheatem and Howe";
      
      test(': concat()', () {
        expect('Dewey'.concat(' Cheatem').concat(' and').concat( ' Howe'), equals(string)); 
      });
    
      test(': join()', () {
        expect(['Dewey', 'Cheatem', 'and', 'Howe'].join(' '), equals(string));
      });
    });
  });
}