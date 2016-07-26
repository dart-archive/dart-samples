//
// Run "dart generate_md_for_dartlang.dart > index.md".
// Copy that file to /dart-vm/dart-by-example in the www repo.
// This file uses fodder from README.md and example/* to generate
// the final page.
//
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
title: "Cookbook: Dart by Example"
short-title: "Cookbook"
permalink: /dart-vm/dart-by-example
description: "A cookbook, or set of examples, showing idiomatic Dart code."

header:
  css: ["index.css"]
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
          print('### ${match.group(1)}');
          print('');
          printExample(file.readAsLinesSync());
        } else {
          print(file.readAsStringSync());
        }
      }
    } else {
      // Print non-link lines from the README.
      print(line);
    }
  }
}
