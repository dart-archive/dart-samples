// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

#import('dart:html');
#import('dart:web');

class DndFiles {
  Element _dropZone;
  OutputElement _output;

  DndFiles() {
    _output = document.query('#list');

    // Begin listening to the drop zone for dnd events.
    _dropZone = document.query('#drop-zone');
    _dropZone.on.dragOver.add(_onDragOver);
    _dropZone.on.dragEnter.add((e) => _dropZone.classes.add('hover'));
    _dropZone.on.dragLeave.add((e) => _dropZone.classes.remove('hover'));
    _dropZone.on.drop.add(_onFilesSelected);
  }

  void _onDragOver(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    event.dataTransfer.dropEffect = 'copy';
  }

  void _onFilesSelected(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    _dropZone.classes.remove('hover');

    // Retrieve the list of files and output some of the properties for each.
    var files = event.dataTransfer.files;
    _output.nodes.clear();
    var list = new Element.tag('ul');
    for (var file in files) {
      var item = new Element.tag('li');
      item.innerHTML = new StringBuffer('<strong>')
          .add(htmlEscape(file.name))
          .add('</strong> (')
          .add(file.type != null ? htmlEscape(file.type) : 'n/a')
          .add(') ')
          .add(file.size)
          .add(' bytes')
          // TODO(jason9t): Re-enable this when issue 5070 is resolved.
          // http://code.google.com/p/dart/issues/detail?id=5070
          // .add(', last modified: ')
          // .add(file.lastModifiedDate != null ?
          //     file.lastModifiedDate.toLocal().toString() :
          //     'n/a')
          .toString();
      list.nodes.add(item);
    }
    _output.nodes.add(list);
  }
}

void main() {
  new DndFiles();
}
