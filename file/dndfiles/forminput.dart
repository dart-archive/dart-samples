// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

#import('dart:html');
#import('dart:web');

class FormInput {
  InputElement _filesEl;
  OutputElement _listEl;

  FormInput() {
    _listEl = document.query('#list');

    // Listen to the files input element for changes.
    _filesEl = document.query('#files');
    _filesEl.on.change.add((e) => onFilesSelected());
  }

  void onFilesSelected() {
    var files = _filesEl.files;

    // files is a FileList of File objects. List some properties.
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
  new FormInput();
}
