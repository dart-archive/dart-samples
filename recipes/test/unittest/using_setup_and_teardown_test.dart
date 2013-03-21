import 'package:unittest/unittest.dart';

import 'dart:io';

List<String> createFiles(Map data, Directory directory) {
  var paths = [];
  if  (!directory.existsSync()) {
    throw new ArgumentError('directory does not exist');
  }
  
  var fileList = data.keys;
    
  fileList.forEach((fileName) {
    var path = new Path(directory.path).join(new Path(fileName));
    paths.add(path);
    new File(path.toString()).writeAsStringSync(data[fileName]);
  });
  return paths;
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
    var data = {'a.txt' : 'Contents of a.txt',
                'b.txt' : 'Contents of b.txt'};
    setUp(() {
      tempDir = new Directory('').createTempSync();
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('creates the correct path', () {
      var paths = createFiles(data, tempDir);
      expect(new Path(tempDir.path).join(new Path('a.txt')).toString(), 
          equals(paths.first.toString()));
    });
    
    test('writes file content', () {
      var paths = createFiles(data, tempDir);  
      var content = new File.fromPath(paths.first).readAsStringSync();
      expect(content, equals('Contents of a.txt'));
    });
    
    test('throws with a non-existent directory', () {
      tempDir.deleteSync(recursive: true);
      expect(() {
        var paths = createFiles(data, tempDir);
      }, throwsArgumentError);
    });
  });
}