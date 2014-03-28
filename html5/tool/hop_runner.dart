library hop_runner;

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

import 'package:html5lib/parser.dart' show parse;

Iterable<String> getHtmlPaths() {
  return new Directory('web').listSync(recursive: true, followLinks: false)
      .map((File file) => file.path)
      .where((_path) => path.extension(_path) == ".html");
}

List<String> getDartPaths(htmlPaths) {
  List<String> paths = [];
  for (var htmlPath in htmlPaths) {
    var file = new File(htmlPath).readAsStringSync();
    var contents = parse(file);
    var scripts = contents.body.querySelectorAll("script");
    if (!scripts.isEmpty) {
      for(var script in scripts) {
        if (script.attributes['type'] == 'application/dart') {
          // Links to .dart files may not always be in the same directory as
          // the .html file. The following line computes the correct path of
          // the .dart file.
          // So, given a web/app/index.html file that contains a
          // <script type='application/dart' src=../../foo.dart'> tag, the .dart
          // file is correctly identified as web/foo.dart.
          paths.add(path.normalize(path.join(
              path.dirname(htmlPath), script.attributes['src'])));
        }
      }
    }
  }
  return paths;
}

void main(List<String> args) {
  var paths = getDartPaths(getHtmlPaths());
  print(paths);
  addTask('analyze_libs', createAnalyzerTask(paths));
  runHop(args);
}
