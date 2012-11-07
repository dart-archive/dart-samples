// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

import 'dart:html';
import 'package:htmlescape/htmlescape.dart';

class DndFiles {
  FormElement _readForm;
  InputElement _fileInput;
  Element _dropZone;
  OutputElement _output;

  DndFiles() {
    _output = document.query('#list');
    _readForm = document.query('#read');
    _fileInput = document.query('#files');
    _fileInput.on.change.add((e) => _onFileInputChange());

    _dropZone = document.query('#drop-zone');
    _dropZone.on.dragOver.add(_onDragOver);
    _dropZone.on.dragEnter.add((e) => _dropZone.classes.add('hover'));
    _dropZone.on.dragLeave.add((e) => _dropZone.classes.remove('hover'));
    _dropZone.on.drop.add(_onDrop);
  }

  void _onDragOver(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    event.dataTransfer.dropEffect = 'copy';
  }

  void _onDrop(MouseEvent event) {
    event.stopPropagation();
    event.preventDefault();
    _dropZone.classes.remove('hover');
    _readForm.reset();
    _onFilesSelected(event.dataTransfer.files);
  }

  void _onFileInputChange() {
    _onFilesSelected(_fileInput.files);
  }

  void _onFilesSelected(List<File> files) {
    _output.nodes.clear();
    var list = new Element.tag('ul');
    for (var file in files) {
      var item = new Element.tag('li');

      // If the file is an image, read and display its thumbnail.
      if (file.type.startsWith('image')) {
        var thumbHolder = new Element.tag('span');
        var reader = new FileReader();
        reader.on.load.add((e) {
          var thumbnail = new ImageElement(src: reader.result);
          thumbnail.classes.add('thumb');
          thumbnail.title = htmlEscape(file.name);
          thumbHolder.nodes.add(thumbnail);
        });
        reader.readAsDataURL(file);
        item.nodes.add(thumbHolder);
      }

      // For all file types, display some properties.
      var properties = new Element.tag('span');
      properties.innerHTML = new StringBuffer('<strong>')
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
      item.nodes.add(properties);
      list.nodes.add(item);
    }
    _output.nodes.add(list);
  }
}

void main() {
  new DndFiles();
}
