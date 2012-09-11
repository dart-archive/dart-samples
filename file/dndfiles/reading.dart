// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

#import('dart:html');
#import('dart:web');

class Reading {
  InputElement _fileInput;
  OutputElement _output;

  Reading() {
    _output = query('#list');

    // Listen to the files input element for changes.
    _fileInput = query('#files');
    _fileInput.on.change.add((e) => _onFilesSelected());
  }

  void _onFilesSelected() {
    // Loop through the file list and render image files as thumbnails.
    _output.nodes.clear();
    var files = _fileInput.files;
    var imageFileCount = 0;
    for (var file in files) {
      if (file.type.startsWith('image')) {
        var reader = new FileReader();
        reader.on.load.add((e) {
          var thumbnail = new ImageElement(reader.result);
          thumbnail.classes.add('thumb');
          thumbnail.title = htmlEscape(file.name);
          var span = new Element.tag('span');
          span.nodes.add(thumbnail);
          _output.nodes.add(span);
        });
        reader.readAsDataURL(file);
        imageFileCount++;
      }
    }

    // If there were no image files, prompt the user.
    if (imageFileCount < 1) {
      window.alert('Please select one or more image files!');
    }
  }
}

void main() {
  new Reading();
}
