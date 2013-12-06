import 'dart:io';
import "package:unittest/unittest.dart";

void main() {
  group('parse', () {
    test('segments', () {
      expect(new Path('/usr/local/bin/').segments(),
          equals(['usr', 'local', 'bin']));
      expect(new Path('../../file.txt').segments(),
          equals(['..', '..', 'file.txt']));
    });

    test('directoryPath', () {
      expect(new Path('/path/to/file.txt').directoryPath.segments(),
          equals(['path', 'to']));

      expect(new Path('../img/logo.png').directoryPath.segments(),
          equals(['..', 'img']));

      // If no file.
      expect(new Path('/usr/local/').directoryPath.segments(),
          equals(['usr', 'local']));

      // If there is no '/' in the Path, returns the empty string.
      expect(new Path('book.txt').directoryPath.segments(), equals(['']));

      // If the only '/' in this Path is the first character, returns '/'
      // instead of the empty string.
      expect(new Path('/src').directoryPath.toString(), equals('/'));
      expect(new Path('/').directoryPath.toString(), equals('/'));
    });

    test('filename', () {
      // The part of the path after the last '/', or the entire path if it
      // contains no '/'.
      expect(new Path('imgs/logo.png').filename, equals('logo.png'));
      expect(new Path('logo.png').filename, equals('logo.png'));
      expect(new Path('/usr/local/').filename, isEmpty);
    });

    test('filenameWithoutExtension', () {
      expect(new Path('/c:/docs/book.txt').filenameWithoutExtension,
          equals('book'));
    });

    test('extension', () {
      // The part of filename after the last '.', or '' if filename
      // contains no '.'. If filename is '.' or '..', returns ''.
      expect(new Path('imgs/logo.png').extension, equals('png'));
      expect(new Path('/lib/src/core').extension, equals(''));
    });
  });
}