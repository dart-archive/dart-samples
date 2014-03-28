// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Reading Files in JavaScript Using the File APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/dndfiles/

import 'dart:html';
import 'dart:math';
import 'dart:async';

class Monitoring {
  InputElement _fileInput;
  Element _progressBar;
  FileReader _reader;

  Monitoring() {
    _progressBar = querySelector('#progress-bar');
    _fileInput = document.querySelector('#files');
    _fileInput.onChange.listen((e) => _onFilesSelected());
    var cancelButton = querySelector('#cancel-read');
    cancelButton.onClick.listen((e) => _onCancel());
  }

  void _setProgress(int value) {
    value = min(100, max(0, value));
    _progressBar.style.width = '${value}%';
    _progressBar.text = '${value}%';
    if (value == 0 || value == 100) {
      new Timer(const Duration(milliseconds: 2000), () => _progressBar.classes.remove('loading'));
    }
  }

  void _onFilesSelected() {
    // Reset progress indicator on new file selection.
    _setProgress(0);
    _progressBar.classes.remove('loading');

    // Set up handlers and begin reading the file.
    var file = _fileInput.files[0];
    _reader = new FileReader();
    _reader.onError.listen((e) => _onError());
    _reader.onProgress.listen(_onProgress);
    _reader.onAbort.listen((e) => window.alert('File read cancelled.'));
    _reader.onLoadStart.listen((e) => _progressBar.classes.add('loading'));
    _reader.onLoad.listen((e) => _setProgress(100));
    _reader.readAsText(file);
  }

  void _onCancel() {
    if (_reader != null) {
      _reader.abort();
    }
  }

  void _onProgress(ProgressEvent event) {
    if (event.lengthComputable) {
      var percentLoaded = (100 * event.loaded / event.total).round().toInt();
      _setProgress(percentLoaded);
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
        break;
    }
  }
}

void main() {
  new Monitoring();
}
