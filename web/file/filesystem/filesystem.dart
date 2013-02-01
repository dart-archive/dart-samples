// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Exploring the FileSystem APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/filesystem/

import 'dart:html';
import 'package:dart_html5_samples/htmlescape.dart';

class FileSystemExample {
  FileSystem _filesystem;
  Element _fileList;

  FileSystemExample() {
    _fileList = query('#example-list-fs-ul');
    window.requestFileSystem(Window.TEMPORARY, 1024 * 1024,
        _requestFileSystemCallback, _handleError);
  }

  void _requestFileSystemCallback(FileSystem filesystem) {
    _filesystem = filesystem;
    query('#add-button').on.click.add((e) => _addFiles());
    query('#list-button').on.click.add((e) => _listFiles());
    query('#remove-button').on.click.add((e) => _removeFiles());
  }

  void _handleError(FileError e) {
    var msg = '';
    switch (e.code) {
      case FileError.QUOTA_EXCEEDED_ERR:
        msg = 'QUOTA_EXCEEDED_ERR';
        break;
      case FileError.NOT_FOUND_ERR:
        msg = 'NOT_FOUND_ERR';
        break;
      case FileError.SECURITY_ERR:
        msg = 'SECURITY_ERR';
        break;
      case FileError.INVALID_MODIFICATION_ERR:
        msg = 'INVALID_MODIFICATION_ERR';
        break;
      case FileError.INVALID_STATE_ERR:
        msg = 'INVALID_STATE_ERR';
        break;
      default:
        msg = 'Unknown Error';
        break;
    }
    query("#example-list-fs-ul").text = "Error: $msg";
  }

  void _addFiles() {
    _filesystem.root.getFile('log.txt', options: {"create": true}, errorCallback: _handleError);
    _filesystem.root.getFile('song.mp3', options: {"create": true}, errorCallback: _handleError);
    _filesystem.root.getDirectory('mypictures', options: {"create": true}, errorCallback: _handleError);
    _fileList.text = 'Files created.';
  }

  void _listFiles() {
    var dirReader = _filesystem.root.createReader();
    dirReader.readEntries((entries) {
      if (entries.length == 0) {
        _fileList.text = 'Filesystem is empty.';
      } else {
        _fileList.text = '';
      }

      var fragment = document.createDocumentFragment();
      entries.forEach((entry) {
        var img = entry.isDirectory ? '<img src="http://www.html5rocks.com/static/images/tutorials/icon-folder.gif">' :
                                      '<img src="http://www.html5rocks.com/static/images/tutorials/icon-file.gif">';
        var li = new Element.tag("li");
        li.innerHtml = "$img<span>${htmlEscape(entry.name)}</span>";
        fragment.nodes.add(li);
      });
      _fileList.nodes.add(fragment);
    }, _handleError);
  }

  void _removeFiles() {
    var dirReader = _filesystem.root.createReader();
    dirReader.readEntries((entries) {
      entries.forEach((entry) {
        if (entry.isDirectory) {
          entry.removeRecursively(() {}, _handleError);
        } else {
          entry.remove(() {}, _handleError);
        }
      });
      _fileList.text = 'Directory emptied.';
    }, _handleError);
  }
}

void main() {
  new FileSystemExample();
}