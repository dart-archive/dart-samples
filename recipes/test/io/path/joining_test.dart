import 'dart:io';
import "package:unittest/unittest.dart";

void main() {

  try {
    new Path('Users/shailen/').join(new Path('/docs'));
  } catch(e) {
    print(e);
  }


  group('join', () {
    test('', () {
      Path path = new Path('/Users/shailen').join(new Path('dart/projects'));
      expect(path.toString(), equals('/Users/shailen/dart/projects'));
    });

    test('', () {
      Path path = new Path('../../apps').join(new Path('dart/mobile'));
      expect(path.toString(), equals('../../apps/dart/mobile'));
    });

    test('', () {
      Path path = new Path('Users/shailen/docs').join(new Path('../../john'));
      expect(path.toString(), equals('Users/john'));
    });

    test('', () {
      Path path = new Path('Users/shailen/books.txt').join(new Path('todos.txt'));
      expect(path.toString(), equals('Users/shailen/books.txt/todos.txt'));
    });

    test('using illegal absolute path as arg', () {
      expect(() => new Path('Users/shailen/').join(new Path('/docs')),
          throwsA(predicate((e) => (e is ArgumentError &&
              e.message == 'Path.join called with absolute Path as argument.'))));
      // Illegal argument(s): Path.join called with absolute Path as argument.
    });

    test('joining to basepath', () {
      Path path = new Path('Users/shailen/books.txt').directoryPath.join(new Path('todos.txt'));
      expect(path.toString(), equals('Users/shailen/todos.txt'));
    });

    test('joining to basepath', () {
      Path path = new Path('Users/shailen/books.txt').directoryPath.join(new Path('../john'));
      expect(path.toString(), equals('Users/john'));
    });
  });
}