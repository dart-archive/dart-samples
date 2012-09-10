// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

#import('dart:html');
#import('dart:math');

class Monitoring {
  InputElement _filesEl;
  Element _progressBar;
  FileReader _reader;

  Monitoring() {
    _progressBar = query('#progress-bar');

    // Listen to the files input element for changes.
    _filesEl = document.query('#files');
    _filesEl.on.change.add((e) => _onFilesSelected());

    // Listening for a read cancel event.
    var cancelButton = query('#cancel-read');
    cancelButton.on.click.add((e) => _onCancel());
  }

  void _setProgress(int value) {
    value = min(100, max(0, value));
    _progressBar.style.width = '${value}%';
    _progressBar.text = '${value}%';
    if (value == 0 || value == 100) {
      window.setTimeout(() => _progressBar.classes.remove('loading'), 2000);
    }
  }

  void _onFilesSelected() {
    // Reset progress indicator on new file selection.
    _setProgress(0);
    _progressBar.classes.remove('loading');

    // Set up handlers and begin reading the file.
    var file = _filesEl.files[0];
    _reader = new FileReader();
    _reader.on.error.add((e) => _onError());
    _reader.on.progress.add(_onProgress);
    _reader.on.abort.add((e) => window.alert('File read cancelled.'));
    _reader.on.loadStart.add((e) => _progressBar.classes.add('loading'));
    _reader.on.load.add((e) => _setProgress(100));
    _reader.readAsBinaryString(file);
  }

  void _onCancel() {
    if (_reader != null) {
      _reader.abort();
    }
  }

  void _onProgress(ProgressEvent event) {
    if (event.lengthComputable) {
      var percentLoaded = (100 * event.loaded / event.total).round().toInt();
      if (percentLoaded < 100) {
        _setProgress(percentLoaded);
      }
    }
  }

  void _onError() {
    switch(_reader.error.code) {
      case FileError.NOT_FOUND_ERR:
        window.alert('File not found!');
        break;
      case FileError.NOT_READABLE_ERR:
        window.alert('File is not readable.');
        break;
      case FileError.ABORT_ERR:
        break;  // no-op.
      default:
        window.alert('An error occurred reading this file.');
    }
  }
}

void main() {
  new Monitoring();
}