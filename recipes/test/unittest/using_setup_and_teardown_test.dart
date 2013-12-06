import 'package:unittest/unittest.dart';

import 'dart:io';

Path writeFileToDirectory(dir) {
  if  (!dir.existsSync()) {
    throw new ArgumentError('directory does not exist');
  }
  var path = new Path(dir.path).join(new Path('example.txt'));
  new File(path.toString()).writeAsStringSync('some content');
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
  
  group('test Point with nested setUp()', () {
    Point point;
    setUp(() {  
      point = new Point(3, 4);
    });
    
    test('toString', () {
      expect(point.toString(), equals('Point: x = 3, y = 4'));
    });
    
    group('[]()', () {
      test('with valid index', () {
        expect(point[0], equals(3));
        expect(point[1], equals(4));
      });
      
      test('with invalid index', () {
        expect(() => point[2], throws);
      });
    });
  });
  
  group('test writeFileToDirectorys()', () {
    var tempDir;

    setUp(() {
       tempDir = new Directory('').createTempSync();
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('creates the correct path', () {
      var path = writeFileToDirectory(tempDir);
      expect(new Path(tempDir.path).join(new Path('example.txt')).toString(), 
          equals(path.toString()));
    });
    
    test('throws with a non-existent directory', () {
      tempDir.deleteSync(recursive: true);
      expect(() {
        var paths = writeFileToDirectory(tempDir);
      }, throwsArgumentError);
    });
  });
  

//  group('', () {
//    var tempDir;
//
//    setUp(() {
//      print('setting up');
//      tempDir = new Directory('').createTempSync();
//    });
//
//    tearDown(() {
//      print('tearing down\n');
//      if (tempDir.existsSync()) {
//        tempDir.deleteSync(recursive: true);
//      }
//    });
//    
//    test('tearDown behavior when test has error in it', () {
//      tempDir.deleteSync(recursive: true);
//      22 ~/ 0;
//      expect(() {
//        var paths = writeFileToDirectory(tempDir);
//      }, throwsArgumentError);
//    });
//  });
}