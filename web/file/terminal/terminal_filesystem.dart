// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Exploring the FileSystem APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/filesystem/

library terminal_filesystem;
import 'dart:html';
part 'terminal.dart';

class TerminalFilesystem {
  Terminal term;

  void run() {
    term = new Terminal('#input-line', '#output', '#cmdline');
    term.initializeFilesystem(false, 1024 * 1024);
    
    if (!window.location.hash.isEmpty) {
      var theme = window.location.hash.substring(1, window.location.hash.length).split('=')[1];
      term.setTheme(theme);
    } else if (window.localStorage.containsKey('theme')) {
      term.setTheme(window.localStorage['theme']);
    }
    
    // Setup the DnD listeners for file drop. 
    var body = document.body;
    body.on.dragEnter.add(onDragEnter);
    body.on.dragOver.add(onDragOver);
    body.on.drop.add(onDrop);
  }
  
  void onDragEnter(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    Element dropTarget = event.target;
    dropTarget.classes.add('dropping');
  }
  
  void onDragOver(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    
    // Explicitly show this is a copy.
    event.dataTransfer.dropEffect = 'copy'; 
  }
  
  void onDrop(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    Element dropTarget = event.target;
    dropTarget.classes.remove('dropping');
    term.addDroppedFiles(event.dataTransfer.files);
    term.writeOutput('<div>File(s) added!</div>');
  }
}

/**
 * Escapes HTML-special characters of [text] so that the result can be
 * included verbatim in HTML source code, either in an element body or in an
 * attribute value.
 * 
 * TODO(jjinux): We can remove this once this bug is fixed:
 * http://code.google.com/p/dart/issues/detail?id=1657
 */
String htmlEscape(String text) {
  // TODO(efortuna): A more efficient implementation.
  return text.replaceAll("&", "&amp;")
             .replaceAll("<", "&lt;")
             .replaceAll(">", "&gt;")
             .replaceAll('"', "&quot;")
             .replaceAll("'", "&apos;");
}

void main() {
  new TerminalFilesystem().run();
}
