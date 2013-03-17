#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';

var content = '';
bool _headersConverted = false;
var stateErrorMessage = "Call convertHeaders() first.";

var preface = '''---
layout: default
title: "Dart Cookbook"
description: "Tasty recipes to make you more productive with Dart."
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
  return title.trim().toLowerCase().replaceAll(' ', '_');  
}

/// Generates TOC.
String generateTOC() {
  if (!_headersConverted) {
    throw new StateError('Error inside generateTOC: $stateErrorMessage');
  }
  var sb = new StringBuffer();
  var regExp = new RegExp(r'(^#{1,3}) ([\w\s]+)\n', multiLine: true);
  var matches = regExp.allMatches(content);
  var closingTags = new List<String>();
  
  var h2ClosingTags = [];
  bool firstH2 = true;
  
  // The <ol> for the TOC.
  sb.write('<ol>\n');
  
  matches.forEach((match) {
    var hType = match.group(1);
    var text = match.group(2).trim();
    if (hType == "##") {
      if (!h2ClosingTags.isEmpty) {
        sb.write(h2ClosingTags.removeLast());
      }
      sb.write('<li><a href="#${getHref(text)}">$text</a><ol>\n');
      h2ClosingTags.addAll(['</li>\n', '</ol>\n']);
    } else if (hType == "###") {
      sb.write('<li><a href="${getHref(text)}">$text</a></li>\n');      
    }
  });
  
  // Final H2 closing tag (only H2's nest).
  sb.write('\n</ol>\n<li>');

  // Add final TOC closing tag.
  sb.write('\n</ol>'); 
  return sb.toString();
}


/// Makes all h3 elements named anchors.
void generateH3Anchors() {
  if (!_headersConverted) {
    throw new StateError('Error inside generateH3Anchors: $stateErrorMessage');
  }
  var regExp = new RegExp(r'(\n### )([[A-Z][\w\s]+)\n');
  content = content.replaceAllMapped(regExp, (match) {
    var anchorId = match.group(2).toLowerCase().replaceAll(' ', '_').trim();
    return('\n<h3><a id="${anchorId}" href="#${anchorId}">${match.group(2).trim()}</a></h3>\n\n');  
  });
}


/// Converts asciidoc code delimiters ('-------') to <pre> tags.
void generatePreTags() {
  if (!_headersConverted) {
    throw new StateError('Error inside generatePreTags: $stateErrorMessage');
  }
  var regExp = new RegExp('\n\n-+\n');
  var matches = regExp.allMatches(content);
  content = content.replaceAll(regExp, '\n\n<pre class="programlisting">\n');
  
  regExp = new RegExp('\n-+\n\n');
  matches = regExp.allMatches(content); 
  content = content.replaceAll(regExp, '\n</pre>\n\n');
}


/// Writes generated content to out file.
void writeToOutputFile(File outFile, preface, toc) {
  outFile.writeAsStringSync(preface);
  outFile.writeAsStringSync(toc, mode: FileMode.APPEND);
  outFile.writeAsStringSync(content, mode: FileMode.APPEND);
}


void main() {  
  var args = new Options().arguments;
  if (args.length != 1) {
    print("Usage: format_for_dartlang.dart newfile");
    exit(1);
  }
  
  var outFile = new File(args[0]);
  var sourceFile = 'book.asciidoc';
  var file = new File(sourceFile);
 
  content = file.readAsStringSync(); 
  stripPreface();
  convertHeaders();
  
  var toc = generateTOC();
  generateH3Anchors();
  generatePreTags();

  writeToOutputFile(outFile, preface, toc);
}
