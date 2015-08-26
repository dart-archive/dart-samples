import 'dart:io';
import 'package:path/path.dart' as PATH;

// text.gsub /\[([^\]]+)\]\(([^)]+)\)/, '<a href="\2">\1</a>'

printExample(List<String> lines) {
  var i = 0;
  for (; i < lines.length; i++) {
    var line = lines[i].trim();
    // Get the first non-empty, non-comment line.
    if (line.startsWith('//') || (line.isEmpty)) {
      if (line.startsWith('/// ')) {
        print(line.substring(3).trim());
      }
    } else {
      break;
    }
  }
  print('');
  print('{% prettify dart %}');
  print(lines.getRange(i, lines.length).join('\n'));
  print('{% endprettify %}');
  print('');
}

const fileHeader = '''
---
layout: default
header:
  css: ["index.css"]
has-permalinks: true
---

''';

main() {
  print(fileHeader);

  // RegExp to match a markdown link such as [Google](http://google.com)
  var regExp = new RegExp(r'\[([^\]]+)\]\(([^)]+)\)');
  var readme = new File('README.md').readAsLinesSync();
  for (var line in readme) {
    line = line.trim();
    if (line.startsWith("*")) {
      if (regExp.hasMatch(line)) {
        var match = regExp.firstMatch(line);
        print('');
        var abspath = PATH.absolute(match.group(2));
        var file = new File(abspath);

        if (PATH.extension(abspath) != '.md') {
          print('#### ${match.group(1)}');
          print('');
          printExample(file.readAsLinesSync());
        } else {
          print(file.readAsStringSync());
        }
      }
    } else {
      // Print non-link lines from the README.
      print(line);
      // Title line.
      if (line.startsWith('## ')) {
        print('{:.no_toc}');
        print('');
        print('{% include default_toc.html %}');
      }
    }
  }
}
