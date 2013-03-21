import 'package:unittest/unittest.dart';

import 'dart:io';

Path createFile(fileName, fileContent, directory) {
  if  (!directory.existsSync()) {
    throw new ArgumentError('directory does not exist');
  }
  var path = new Path(directory.path).join(new Path(fileName));
  new File(path.toString()).writeAsStringSync(fileContent);
  return path;
}

class Point {
  num x, y;
  
  Point(this.x, this.y);
  
  String toString() => 'Point: x = $x, y = $y';
  
  num operator [](index) {
    if (index < 0 || index > 1) {
       throw new ArgumentError('only 0 and 1 are valid indices'); 
    }
    return (index == 0) ? x : y;
  }
}

void main() {
  group('test Point', () {
    test('toString', () {
      Point point = new Point(3, 4);
      expect(point.toString(), equals('Point: x = 3, y = 4'));
    });
    
    test('[](index)', () {
      Point point = new Point(3, 4);
      expect(point[0], equals(3));
      expect(point[1], equals(4));
    });
  });
  
  group('test Point with setUp()', () {
    Point point;
    setUp(() {  
      point = new Point(3, 4);
    });

    test('toString', () {
      expect(point.toString(), equals('Point: x = 3, y = 4'));
    });
    
    test('[](index)', () {
      expect(point[0], equals(3));
      expect(point[1], equals(4));
    });
  });
  
  
  group('test createFiles()', () {
    var tempDir;
    var fileName = 'a.txt';
    var fileContent = 'Content of a.txt';
    
    setUp(() {
       tempDir = new Directory('').createTempSync();
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('creates the correct path', () {
      var path = createFile(fileName, fileContent, tempDir);
      expect(new Path(tempDir.path).join(new Path(fileName)).toString(), 
          equals(path.toString()));
    });
    
    test('throws with a non-existent directory', () {
      tempDir.deleteSync(recursive: true);
      expect(() {
        var paths = createFile(fileName, fileContent, tempDir);
      }, throwsArgumentError);
    });
  });
}