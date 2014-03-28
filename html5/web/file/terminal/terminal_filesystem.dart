// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Exploring the FileSystem APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/filesystem/

library terminal_filesystem;

import 'dart:convert' show HtmlEscape;
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
    body.onDragEnter.listen(onDragEnter);
    body.onDragOver.listen(onDragOver);
    body.onDrop.listen(onDrop);
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

void main() {
  new TerminalFilesystem().run();
}
