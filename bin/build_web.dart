#!/usr/bin/env dart
// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "A Beginner's Guide to Using the Application Cache" to
// Dart. See: http://www.html5rocks.com/en/tutorials/appcache/beginner

// Stored in bin/ for now until tool(s) gets the packages symlink
// TODO(adam): use logger for output
// TODO(adam): limit how many processes 

import 'dart:io';
import 'package:args/args.dart';
import 'package:html5lib/parser.dart' show parse;
import 'package:html5lib/dom.dart';
import 'package:html5lib/parser_console.dart';

void main() {
  var argParser = new ArgParser();
  argParser.addOption('dart2js', abbr: 'd',
      help: 'absolute path for dart2js', defaultsTo: 'dart2js');
  argParser.addOption('web', abbr: 'w',
      help: 'path to web folder', defaultsTo: 'web');
  argParser.addFlag('help', abbr: 'h', help: "help", negatable: false,  callback: (enabled) { 
    if(enabled) {
      print(argParser.getUsage());
      exit(0);
    }
  });
  
  var args = argParser.parse(new Options().arguments);
  var dart2js = args['dart2js'];
  var webFolder = args['web'];
  
  // set html5lib parser in console mode
  useConsole();
  
  Directory directory = new Directory.fromPath(new Path(webFolder));
  DirectoryLister directoryLister = directory.list(recursive: true);
  directoryLister.onError = (error) {
    print("Not able to list directory $webFolder, $error");
    exit(0);
  };
  
  directoryLister.onFile = (String file) {
    // Ignore paths that get introduced by pub's packages folder
    if (file.contains('.pub-cache') || file.contains('dart-sdk')) { 
      return; 
    }
    
    Path path = new Path(file);
    // Search for index.html files to parse the associated dart files. 
    if (path.filename == 'index.html') {
      generateJavascriptCode(dart2js, path);
    }
  };
  
}

void generateJavascriptCode(String dart2js, Path path) {
  var file = new File.fromPath(path).openSync();
  Document doc = parse(file);
  var scripts = doc.body.queryAll("script");
  scripts.forEach((Element script) { 
    Map attributes = script.attributes;
    if (attributes.containsKey('type') && 
        attributes.containsValue('application/dart') && 
        attributes.containsKey('src')) {
      ProcessOptions processOptions = new ProcessOptions();
      processOptions.workingDirectory = path.directoryPath.toString();
      processOptions.environment = new Map();
      var processArgs = ["--verbose", "-o${attributes['src']}.js", "${attributes['src']}"];
      print("Starting build of ${processOptions.workingDirectory}/${attributes['src']}.js");
      Process.run(dart2js, processArgs, processOptions)
      ..handleException((error) {
        print("Error building ${processOptions.workingDirectory}/${attributes['src']}.js");
        print(error);
      })
      ..then((ProcessResult processResult) {
        print("Success building ${processOptions.workingDirectory}/${attributes['src']}.js");
      });
    }
  });
}