library concatenating_strings_test;

import 'package:unittest/unittest.dart';

String filmToWatch() => 'The Big Lebowski';

void main() { 
  group('concatenating strings', () {
    group('using +', () {
      test('', () {
        expect('Dart' + ' is' + ' fun!', equals('Dart is fun!'));
      });
      
      test('over many lines', () {
        expect('Dart' + 
            ' is' 
            ' fun!', equals('Dart is fun!'));
      });
      
      test('over one or many lines', () {
        expect('Dart' + ' is' + 
            ' fun!', equals('Dart is fun!'));
      });
      
      test('using multiline strings', () {
        expect('''Peanut
butter ''' + 
'''and
jelly''', equals('Peanut\nbutter and\njelly'));
      });
        
      test('combining single and multiline string', () {
        expect('Dewey ' + 'Cheatem'
            ''' and
Howe''', equals('Dewey Cheatem and\nHowe'));
      });
    });
      
    group('using adjacent string literals', () {
      test('on one line', () {
        expect('Dart' ' is' ' fun!', equals('Dart is fun!'));
      });
      
      test('over many lines', () {
        expect('Dart' 
            ' is' 
            ' fun!', equals('Dart is fun!'));
      });
      
      test('over one or many lines', () {
        expect('Dart' ' is' 
            ' fun!', equals('Dart is fun!'));
      });
      
      test('using multiline strings', () {
        expect('''Peanut
butter '''
'''and
jelly''', equals('Peanut\nbutter and\njelly'));
      });
        
      test('combining single and multiline string', () {
        expect('Dewey ' 'Cheatem'
            ''' and
Howe''', equals('Dewey Cheatem and\nHowe'));
      });
    });
  
    group('using alternatives to string literals', () {
      test(': join()', () {
        expect(['The', 'Big', 'Lebowski'].join(' '), equals('The Big Lebowski'));
      });
    });
  });
}
