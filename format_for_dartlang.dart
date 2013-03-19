#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';

var content = '';
bool _headersConverted = false;
var stateErrorMessage = "Call convertHeaders() first.";

var preface = '''---
layout: default
title: "Dart Cookbook"
description: "Recipes and prescriptions for using Dart."
has-permalinks: true
---

# Dart Cookbook

## Contents
''';

/// Removes the asciidoc header.
void stripPreface() {
  // Strip preface.
  var regExp = new RegExp(r'= Dart Cookbook\n:author: Shailen Tuli\n:encoding: UTF-8');
  content = content.replaceFirst(regExp, '');
}

/// Converts asciidoc === tags to equivalent markdown ### tags.
void convertHeaders() {  
  var regExp = new RegExp('\n(={1,6}) ');
  content = content.replaceAllMapped(regExp, (match) {
    var oldTag = match.group(1);
    var newTagList = [];
    for (var i = 0; i < oldTag.length; i++) {
      newTagList.add("#");
    }
    return "\n${newTagList.join('')} ";
  });
  _headersConverted = true;
}

String getHref(title) {
  return title.trim().toLowerCase().replaceAll(' ', '-');  
}

/// Generates TOC. 
String generateTOC() {
  if (!_headersConverted) {
    throw new StateError('Error inside generateTOC: $stateErrorMessage');
  }
  var sb = new StringBuffer();
  sb.write('\n');
  var regExp = new RegExp(r'(^#{1,3}) ([\w\s]+)\n', multiLine: true);
  var matches = regExp.allMatches(content);
 
  matches.forEach((match) {
    var hType = match.group(1);
    var text = match.group(2).trim();
    if (hType == "##") {
      sb.write('1. [$text](#${getHref(text)})\n');
    } else if (hType == "###") {
      sb.write('    1. [$text](#${getHref(text)})\n');     
    }
  });
  sb.write('{:.toc}\n\n');
  return sb.toString();
}


/// Converts asciidoc code delimiters ('-------') to prettify tags.
void generatePreTags() {
  if (!_headersConverted) {
    throw new StateError('Error inside generatePreTags: $stateErrorMessage');
  }
  var regExp = new RegExp('\n\n-+\n');
  var matches = regExp.allMatches(content);
  content = content.replaceAll(regExp, '\n\n{% prettify dart %}\n');
  
  regExp = new RegExp('\n-+\n\n');
  matches = regExp.allMatches(content); 
  content = content.replaceAll(regExp, '\n{% endprettify %}\n\n');
}


/// Writes generated content to out file.
void writeToOutputFile(File outFile, preface, toc) {
  outFile.writeAsStringSync(preface);
  outFile.writeAsStringSync(toc, mode: FileMode.APPEND);
  outFile.writeAsStringSync(content, mode: FileMode.APPEND);
}


void main() {  
  var outFileName = 'index.markdown';
  var args = new Options().arguments;
  if (args.length > 0) {
    outFileName = args[0];
  }
  
  var outFile = new File(outFileName);
  var sourceFile = 'book.asciidoc';
  var file = new File(sourceFile);
 
  content = file.readAsStringSync(); 
  stripPreface();
  convertHeaders();
  
  var toc = generateTOC();
  generatePreTags();

  writeToOutputFile(outFile, preface, toc);
}
