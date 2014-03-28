// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

import 'dart:html';

class Slicing {
  InputElement _fileInput;
  Element _content;
  Element _byteRange;

  Slicing() {
    _content = querySelector('#byte-content');
    _byteRange = querySelector('#byte-range');

    _fileInput = querySelector('#files');
    _fileInput.onChange.listen((e) {
      _content.text = '';
      _byteRange.text = '';
    });

    var buttons = querySelector('#read-bytes-buttons');
    buttons.onClick.listen(_onClick);
  }

  void _onClick(MouseEvent event) {
    Element clicked = event.target;
    if (clicked is ButtonElement) {
      var start = clicked.attributes['data-startbyte'];
      var end = clicked.attributes['data-endbyte'];
      _readBlob(
          start != null ? int.parse(start) : null,
          end != null ? int.parse(end) : null);
    }
  }

  void _readBlob([int startByte, int endByte]) {
    var files = _fileInput.files;
    if (files.length == 0) {
      window.alert('Please select a file!');
      return;
    }

    var file = files[0];
    var start = startByte != null ? startByte : 0;
    var end = endByte != null ? endByte : file.size;
    var reader = new FileReader();
    reader.onLoad.listen((e) {
      _content.text = reader.result;
      _byteRange.text =
          'Read bytes ${start + 1} - ${end + 1} of ${file.size}.';
    });
    var slice = file.slice(start, end);
    reader.readAsDataUrl(slice);
  }
}

void main() {
  new Slicing();
}
