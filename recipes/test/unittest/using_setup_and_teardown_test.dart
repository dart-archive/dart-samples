import 'package:unittest/unittest.dart';

import 'dart:io';

List<String> createFiles(Directory directory, fileNames) {
  var paths = [];
  if  (!directory.existsSync()) {
    throw new ArgumentError('directory does not exist');
  }
  
  var fileList = fileNames.split('\n');
  print('fileList = $fileList');
  fileList.forEach((fileName) {
    var path = new Path(directory.path).join(new Path(fileName));
    paths.add(path);
    new File(path.toString()).writeAsStringSync('Title: $fileName');
  });
  return paths;
}

void main() {
  group('test createFiles()', () {
    var tempDir;
    setUp(() {
      tempDir = new Directory('').createTempSync();
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('joins paths correctly', () {
      var paths = createFiles(tempDir, 'a.txt');
      expect(new Path(tempDir.path).join(new Path('a.txt')).toString(), 
          equals(paths.first.toString()));
    });
    
    test('creates titles', () {
      var paths = createFiles(tempDir, 'a.txt');  
      var content = new File.fromPath(paths.first).readAsStringSync();
      expect(content, equals('Title: a.txt'));
    });
    
    test('throws with a non-existent directory', () {
      tempDir.deleteSync(recursive: true);
      expect(() {
        var paths = createFiles(tempDir, 'a.txt');
      }, throwsArgumentError);
    });
  });
}