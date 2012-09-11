// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

#import('dart:html');
#import('dart:web');

class FormInput {
  InputElement _fileInput;
  OutputElement _output;

  FormInput() {
    _output = document.query('#list');

    // Listen to the files input element for changes.
    _fileInput = document.query('#files');
    _fileInput.on.change.add((e) => onFilesSelected());
  }

  void onFilesSelected() {
    // Retrieve the list of files and output some of the properties for each.
    var files = _fileInput.files;
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
  new FormInput();
}
