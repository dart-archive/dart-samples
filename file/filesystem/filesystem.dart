// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Exploring the FileSystem APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/filesystem/
//
// XXX: This code is currently blocked on:
// http://code.google.com/p/dart/issues/detail?id=4549&thanks=4549&ts=1345139622
// It works in Dartium, but not in dart2js.

#import('dart:html');
#import('dart:web');

class FileSystemExample {
  DOMFileSystem _filesystem;
  Element _fileList;
  
  FileSystemExample() {
    _fileList = query('#example-list-fs-ul');
    query('#add-button').on.click.add((e) => _addFiles(), false);
    query('#list-button').on.click.add((e) => _listFiles(), false);
    query('#remove-button').on.click.add((e) => _removeFiles(), false);
    _initFileSystem();
  }
  
  bool _handleError(FileError e) {
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
    return true;
  }
  
  void _initFileSystem() {
    window.webkitRequestFileSystem(Window.TEMPORARY, 1024 * 1024,
      (filesystem) => _filesystem = filesystem,
      _handleError);
  }
  
  void _addFiles() {
    if (_filesystem == null) {
      return;
    }

    _filesystem.root.getFile('log.txt', {"create": true}, null, _handleError);
    _filesystem.root.getFile('song.mp3', {"create": true}, null, _handleError);
    _filesystem.root.getDirectory('mypictures', {"create": true}, null, _handleError);
    _fileList.text = 'Files created.';
  }
  
  void _listFiles() {
    if (_filesystem == null) {
      return;
    }

    var dirReader = _filesystem.root.createReader();
    dirReader.readEntries((entries) {
      if (entries.length == 0) {
        _fileList.text = 'Filesystem is empty.';
      } else {
        _fileList.text = '';
      }

      var fragment = document.createDocumentFragment();
      for (var i = 0, entry; (entry = entries.item(i)) != null; i++) {
        var img = entry.isDirectory ? '<img src="http://www.html5rocks.com/static/images/tutorials/icon-folder.gif">' :
                                      '<img src="http://www.html5rocks.com/static/images/tutorials/icon-file.gif">';
        var li = new Element.tag("li"); 
        li.innerHTML = "$img<span>${htmlEscape(entry.name)}</span>";
        fragment.nodes.add(li);
      }
      _fileList.nodes.add(fragment);
    }, _handleError);
  }
  
  void _removeFiles() {
    if (_filesystem == null) {
      return;
    }

    var dirReader = _filesystem.root.createReader();
    dirReader.readEntries((entries) {
      for (var i = 0, entry; (entry = entries.item(i)) != null; i++) {
        if (entry.isDirectory) {
          entry.removeRecursively(() {}, _handleError);
        } else {
          entry.remove(() {}, _handleError);
        }
      }
      _fileList.text = 'Directory emptied.';
    }, _handleError);
  }
}

void main() {
  new FileSystemExample();
}