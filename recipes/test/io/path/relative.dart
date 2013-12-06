import 'dart:io';
import 'package:unittest/unittest.dart';

void main() {
  test('relative paths', () {
    Path path1 = new Path('docs/book.html');
    Path path2 = new Path('articles/list');
    expect(path1.relativeTo(path2).toString(), equals('../../docs/book.html'));
    expect(path2.relativeTo(path1).toString(), equals('../../articles/list'));
  });

  test('testing absolute paths', () {
    Path path1 = new Path('/etc/local');
    Path path2 = new Path('/etc/ssh');
    expect(path1.relativeTo(path2).toString(), equals('../local'));
    expect(path2.relativeTo(path1).toString(), equals('../ssh'));
  });

  test('mixing relative and absolute paths', () {
    Path path1 = new Path('docs/cookbook');
    Path path2 = new Path('/etc/ssh');
    expect(() => path1.relativeTo(path2).toString(), throwsArgumentError);
  });
}