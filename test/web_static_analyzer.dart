#!/usr/bin/env dart
// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:html5lib/parser.dart' show parse;
import 'package:html5lib/dom.dart';
import 'package:html5lib/parser_console.dart';

final List<AnalyzerResult> analyzerResults = new List<AnalyzerResult>();
final List<Path> paths = new List<Path>();
final Logger logger = new Logger("web_static_analyzer");

class AnalyzerResult {
  ProcessResult processResult;
  String fileName;
  Path path;
  AsyncError error;
  AnalyzerResult(this.fileName, this.path, {this.processResult, this.error});
}

Future<AnalyzerResult> analyzer(String dart_analyzer, Path path) {
  var completer = new Completer();
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
      var processArgs = ['--extended-exit-code', attributes['src']];
      logger.info("Starting analyzer on ${processOptions.workingDirectory}/${attributes['src']}");
      Process.run(dart_analyzer, processArgs, processOptions)
      ..catchError((error) {
        logger.severe("error $error");
        logger.severe(processOptions.workingDirectory);
        completer.completeError(error);
      })
      ..then((ProcessResult processResult) {
        var analyzerResult = new AnalyzerResult(attributes['src'], path, processResult: processResult);
        completer.complete(analyzerResult);
      });
    }
  });
  return completer.future;
}

void processResults() {
  StringBuffer finalResults = new StringBuffer();
  StringBuffer verboseOutput = new StringBuffer();
  StringBuffer exitCodeLabels = new StringBuffer();
  int errorsCount = 0;
  int passedCount = 0;
  int warningCount = 0;
  analyzerResults.forEach((AnalyzerResult result) {
    /*
     *  --extended-exit-code : 0 - clean; 1 - has warnings; 2 - has errors
     */
    exitCodeLabels.clear();

    if (result.processResult.exitCode == 0) {
      passedCount++;
      exitCodeLabels.add("PASSED: ");
    } else if (result.processResult.exitCode == 1) {
      warningCount++;
      exitCodeLabels.add("WARNING: ");
    } else if (result.processResult.exitCode == 2) {
      errorsCount++;
      exitCodeLabels.add("ERROR: ");
    }

    finalResults.add(exitCodeLabels.toString());
    finalResults.add("${result.path.directoryPath.toString()}/${result.fileName}\n");

    verboseOutput.add(exitCodeLabels.toString());
    verboseOutput.add("${result.path.directoryPath.toString()}/${result.fileName}\n");
    verboseOutput.add("${result.processResult.stdout}\n");
    verboseOutput.add("${result.processResult.stderr}\n\n");
  });

  finalResults.add("PASSED: ${passedCount}, WARNING: ${warningCount}, ERROR: ${errorsCount}\n");

  print(verboseOutput.toString());
  print(finalResults.toString());

  if (errorsCount > 0) {
    exit(-1);
  } else {
    exit(0);
  }
}

void setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.on.record.add((LogRecord r) {
    StringBuffer sb = new StringBuffer();
    sb
    ..add(r.time.toString())
    ..add(":")
    ..add(r.loggerName)
    ..add(":")
    ..add(r.level.name)
    ..add(":")
    ..add(r.sequenceNumber)
    ..add(": ")
    ..add(r.message.toString());
    print(sb.toString());
  });
}

void main() {
  setupLogger();

  var argParser = new ArgParser();
  argParser.addOption('dart_analyzer', abbr: 'd',
      help: 'absolute path for dart_analyzer', defaultsTo: 'dart_analyzer');
  argParser.addOption('web', abbr: 'w',
      help: 'path to web folder', defaultsTo: 'web');
  argParser.addFlag('help', abbr: 'h', help: "help", negatable: false,  callback: (enabled) {
    if(enabled) {
      print(argParser.getUsage());
      exit(0);
    }
  });

  var args = argParser.parse(new Options().arguments);
  var dart_analyzer = args['dart_analyzer'];
  var webFolder = args['web'];

  // set html5lib parser in console mode
  useConsole();

  Directory directory = new Directory.fromPath(new Path(webFolder));
  DirectoryLister directoryLister = directory.list(recursive: true);
  directoryLister.onError = (error) {
    logger.severe("Not able to list directory $webFolder, $error");
    exit(-1);
  };


  directoryLister.onFile = (String file) {
    // Ignore paths that get introduced by pub's packages folder
    if (file.contains('.pub-cache') || file.contains('dart-sdk')) {
      return;
    }

    Path path = new Path(file);
    // Search for index.html files to parse the associated dart files.
    if (path.filename == 'index.html') {
      paths.add(path);
    }
  };

  directoryLister.onDone = (bool completed) {
    if (!completed) {
      logger.severe("Directory listener did not complete");
      exit(-1);
    }

    void process_paths() {
      if (paths.isEmpty) {
        processResults();
        return;
      }

      var path = paths.removeLast();
      analyzer(dart_analyzer, path)
      ..then((analyzerResult) {
        analyzerResults.add(analyzerResult);
        process_paths();
      })
      ..catchError((error) {
        // Dead exit, we should expect this application to run without faults.
        logger.severe("Error trying to analyze ${path.toString()}");
        logger.severe("$error");
        exit(-1);
      });
    };

    process_paths();
  };
}