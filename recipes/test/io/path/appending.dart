import 'dart:io';
import "package:unittest/unittest.dart";

void main() {
  group('appending', () {
    test('', (() {
      Path path = new Path('/usr/shailen/workspace');
      path = path.append('dart/web');
      expect(path.toString(), equals('/usr/shailen/workspace/dart/web'));
    }));

    test('without canonicalize()', (() {
      Path path = new Path('/usr/shailen/workspace');
      path = path.append('/dart/web');
      expect(path.toString(), equals('/usr/shailen/workspace//dart/web'));
    }));

    test('with canonicalize()', (() {
      Path path = new Path('/usr/shailen/workspace/');
      path = path.append('/dart/web').canonicalize();
      expect(path.toString(), equals('/usr/shailen/workspace/dart/web'));
    }));
  });
}