// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

#import('dart:html');
#import('dart:math');

class Slicing {
  InputElement _filesEl;
  Element _contentEl;
  Element _byteRangeEl;

  Slicing() {
    _contentEl = query('#byte-content');
    _byteRangeEl = query('#byte-range');

    _filesEl = query('#files');
    _filesEl.on.change.add((e) {
      _contentEl.text = '';
      _byteRangeEl.text = '';
    });

    var buttons = query('#read-bytes-buttons');
    buttons.on.click.add(_onClick);
  }

  void _onClick(MouseEvent event) {
    Element clicked = event.target;
    if (clicked is ButtonElement) {
      var start = clicked.attributes['data-startbyte'];
      var end = clicked.attributes['data-endbyte'];
      _readBlob(
          start != null ? parseInt(start) : null,
          end != null ? parseInt(end) : null);
    }
  }

  void _readBlob([int startByte, int endByte]) {
    var files = _filesEl.files;
    if (files.length == 0) {
      window.alert('Please select a file!');
      return;
    }

    var file = files[0];
    var start = startByte != null ? startByte : 0;
    var end = endByte != null ? endByte : file.size;
    var reader = new FileReader();
    reader.on.load.add((e) {
      _contentEl.text = reader.result;
      _byteRangeEl.text =
          'Read bytes ${start + 1} - ${end + 1} of ${file.size}.';
    });
    var slice = file.slice(start, end);
    reader.readAsBinaryString(slice);
  }

}

void main() {
  new Slicing();
}
