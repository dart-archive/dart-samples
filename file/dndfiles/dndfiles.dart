// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

#import('dart:html');
#import('dart:web');

class DndFiles {
  Element _dropZone;
  OutputElement _listEl;

  DndFiles() {
    _listEl = document.query('#list');

    // Begin listening to the to the drop zone for dnd events.
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

    // files is a FileList of File objects. List some properties.
    var files = event.dataTransfer.files;
    _listEl.nodes.clear();
    var list = new Element.tag('ul');
    for (var file in files) {
      var item = new Element.tag('li');
      item.innerHTML = new StringBuffer('<strong>')
          .add(htmlEscape(file.name))
          .add('</strong> (')
          .add(file.type != null ? file.type : 'n/a')
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
    _listEl.nodes.add(list);
  }
}

void main() {
  new DndFiles();
}
