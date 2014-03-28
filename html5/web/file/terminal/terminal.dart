// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Exploring the FileSystem APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/filesystem/

part of terminal_filesystem;

class Terminal {
  FileSystem fs;
  DirectoryEntry cwd;
  String cmdLineContainer;
  String outputContainer;
  String cmdLineInput;
  OutputElement output;
  InputElement input;
  DivElement cmdLine;
  String version = '0.0.1';
  List<String> themes = ['default', 'cream'];
  List<String> history = [];
  int historyPosition = 0;
  Map<String, Function> cmds;
  HtmlEscape sanitizer = new HtmlEscape();

  Terminal(this.cmdLineContainer, this.outputContainer, this.cmdLineInput) {
    cmdLine = document.querySelector(cmdLineContainer);
    output = document.querySelector(outputContainer);
    input = document.querySelector(cmdLineInput);

    // Always force text cursor to end of input line.
    window.onClick.listen((event) => cmdLine.focus());

    // Trick: Always force text cursor to end of input line.
    cmdLine.onClick.listen((event) => input.value = input.value);

    // Handle up/down key presses for shell history and enter for new command.
    cmdLine.onKeyDown.listen(historyHandler);
    cmdLine.onKeyDown.listen(processNewCommand);
  }

  void historyHandler(KeyboardEvent event) {
    var histtemp = "";
    int upArrowKey = 38;
    int downArrowKey = 40;

    /* keyCode == up-arrow || keyCode == down-arrow */
    if (event.keyCode == upArrowKey || event.keyCode == downArrowKey) {
      event.preventDefault();

      // Up or down
      if (historyPosition < history.length) {
        history[historyPosition] = input.value;
      } else {
        histtemp = input.value;
      }
    }

    if (event.keyCode == upArrowKey) { // Up-arrow keyCode
      historyPosition--;
      if (historyPosition < 0) {
        historyPosition = 0;
      }
    } else if (event.keyCode == downArrowKey) { // Down-arrow keyCode
      historyPosition++;
      if (historyPosition >= history.length) {
        historyPosition = history.length - 1;
      }
    }

    /* keyCode == up-arrow || keyCode == down-arrow */
    if (event.keyCode == upArrowKey || event.keyCode == downArrowKey) {
      // Up or down
      input.value = history[historyPosition] != null ? history[historyPosition]  : histtemp;
    }
  }

  void processNewCommand(KeyboardEvent event) {
    int enterKey = 13;
    int tabKey = 9;

    if (event.keyCode == tabKey) {
      event.preventDefault();
    } else if (event.keyCode == enterKey) {

      if (!input.value.isEmpty) {
        history.add(input.value);
        historyPosition = history.length;
      }

      // Move the line to output and remove id's.
      DivElement line = input.parent.parent.clone(true);
      line.attributes.remove('id');
      line.classes.add('line');
      InputElement cmdInput = line.querySelector(cmdLineInput);
      cmdInput.attributes.remove('id');
      cmdInput.autofocus = false;
      cmdInput.readOnly = true;
      output.children.add(line);
      String cmdline = input.value;
      input.value = ""; // clear input

      // Parse out command, args, and trim off whitespace.
      List<String> args;
      String cmd = "";
      if (!cmdline.isEmpty) {
        cmdline.trim();
        args = sanitizer.convert(cmdline).split(' ');
        cmd = args[0];
        args.removeRange(0, 1);
      }

      // Function look up
      if (cmds[cmd] is Function) {
        cmds[cmd](cmd, args);
      } else {
        writeOutput('${sanitizer.convert(cmd)}: command not found');
      }

      window.scrollTo(0, window.innerHeight);
    }
  }

  void initializeFilesystem(bool persistent, int size) {
    cmds = {
      'clear': clearCommand,
      'help': helpCommand,
      'version': versionCommand,
      'cat': catCommand,
      'cd': cdCommand,
      'date': dateCommand,
      'ls': lsCommand,
      'mkdir': mkdirCommand,
      'mv': mvCommand,
      'cp': cpCommand,
      'open': openCommand,
      'pwd': pwdCommand,
      'rm': rmCommand,
      'rmdir': rmdirCommand,
      'theme': themeCommand,
      'who': whoCommand
    };

    writeOutput('<div>Welcome to ${sanitizer.convert(document.title)}! (v$version)</div>');
    writeOutput(new DateTime.now().toLocal().toString());
    writeOutput('<p>Documentation: type "help"</p>');
    window.requestFileSystem(size, persistent: persistent)
    .then(filesystemCallback, onError: errorHandler);
  }

  void filesystemNotInitialized(String cmd, List<String> args) {
    writeOutput('<div>${sanitizer.convert(cmd)}: not available since filesystem was not initialized</div>');
  }

  void filesystemCallback(FileSystem filesystem) {
    fs = filesystem;

    if (fs is FileSystem) {
      cwd = fs.root;
    } else {
      cmds['cat'] = filesystemNotInitialized;
      cmds['cd'] = filesystemNotInitialized;
      cmds['ls'] = filesystemNotInitialized;
      cmds['mkdir'] = filesystemNotInitialized;
      cmds['mv'] = filesystemNotInitialized;
      cmds['cp'] = filesystemNotInitialized;
      cmds['open'] = filesystemNotInitialized;
      cmds['pwd'] = filesystemNotInitialized;
      cmds['rm'] = filesystemNotInitialized;
      cmds['rmdir'] = filesystemNotInitialized;
    }

    // Attempt to create a folder to test if we can.
    cwd.createDirectory('testquotaforfsfolder')
    .then((DirectoryEntry dirEntry) {
      dirEntry.remove().then((_) {}); // If successfully created, just delete it.
    }, onError: (error) {
      if (error.code == FileError.QUOTA_EXCEEDED_ERR) {
        writeOutput('ERROR: Write access to the filesystem is '
            'unavailable. Are you running Google Chrome with '
        '--unlimited-quota-for-files?');
      } else {
        errorHandler(error);
      }
    });
  }

  void errorHandler(error) {
    var msg = '';
    switch (error.code) {
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
      case FileError.TYPE_MISMATCH_ERR:
        msg = 'TYPE_MISMATCH_ERR';
        break;
      default:
        msg = 'FileError = ${error.code}: Error not handled';
        break;
    };
    writeOutput('<div>Error: ${sanitizer.convert(msg)}</div>');
  }

  void invalidOpForEntryType(FileError error, String cmd, String dest) {
    switch (error.code) {
      case FileError.NOT_FOUND_ERR:
        writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(dest)}: No such file or directory<br>');
        break;
      case FileError.INVALID_STATE_ERR:
        writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(dest)}: Not a directory<br>');
        break;
      case FileError.INVALID_MODIFICATION_ERR:
        writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(dest)}: File already exists<br>');
        break;
      default:
        errorHandler(error);
        break;
    }
  }

  void setTheme([String theme='default']) {
    if (theme == null || theme == 'default') {
      window.localStorage.remove('theme');
      document.body.classes.clear();
    } else {
      document.body.classes.add(theme);
      window.localStorage['theme'] = theme;
    }
  }

  void addDroppedFiles(List<File> files) {
    files.forEach((file) {
      cwd.createFile(file.name, exclusive: true)
      .then((FileEntry fileEntry) {
            fileEntry.createWriter().then((FileWriter fileWriter) {
              fileWriter.onError.listen(errorHandler);
              fileWriter.write(file);
            }, onError: errorHandler);
          }, onError: errorHandler);
    });
  }

  void read(String cmd, String path, var callback) {
    cwd.getFile(path).then((FileEntry fileEntry) {
      fileEntry.file().then((file) {
        var reader = new FileReader();
        reader.onLoadEnd.listen((ProgressEvent event) => callback(reader.result));
        reader.readAsText(file);
      }, onError: errorHandler);
    }, onError: (error) {
      if (error.code == FileError.INVALID_STATE_ERR) {
        writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(path)}): is a directory<br>');
      } else if (error.code == FileError.NOT_FOUND_ERR) {
        writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(path)}: No such file or directory<br>');
      } else {
        errorHandler(error);
      }
    });
  }

  void clearCommand(String cmd, List<String> args) {
    output.innerHtml = '';
  }

  void helpCommand(String cmd, List<String> args) {
    StringBuffer sb = new StringBuffer();
    sb.write('<div class="ls-files">');
    cmds.keys.forEach((key) => sb.write('$key<br>'));
    sb.write('</div>');
    sb.write('<p>Add files by dragging them from your desktop.</p>');
    writeOutput(sb.toString());
  }

  void versionCommand(String cmd, List<String> args) {
    writeOutput("$version");
  }

  void catCommand(String cmd, List<String> args) {
    if (args.length >= 1) {
      var fileName = args[0];
      read(cmd, fileName, (result) => writeOutput('<pre>${sanitizer.convert(result)}</pre>'));
    } else {
      writeOutput('usage: ${sanitizer.convert(cmd)} filename');
    }
  }

  void cdCommand(String cmd, List<String> args) {
    var dest = args.join(' ').trim();
    if (dest.isEmpty) {
      dest = '/';
    }

    cwd.getDirectory(dest)
    .then((DirectoryEntry dirEntry) {
      cwd = dirEntry;
      writeOutput('<div>${sanitizer.convert(dirEntry.fullPath)}</div>');
    }, onError: (FileError error) {
      invalidOpForEntryType(error, cmd, dest);
    });
  }

  void dateCommand(String cmd, var args) {
    writeOutput(new DateTime.now().toLocal().toString());
  }

  StringBuffer formatColumns(List<Entry> entries) {
    var maxName = entries[0].name;
    entries.forEach((entry) {
      if (entry.name.length > maxName.length) {
        maxName = entry.name;
      }
    });

    // If we have 3 or less entires, shorten the output container's height.
    var height = entries.length <= 3 ? 'height: ${entries.length}em;' : '${entries.length ~/ 3}em';
    var colWidth = "${maxName.length}em";
    StringBuffer sb = new StringBuffer();
    sb.write('<div class="ls-files" style="-webkit-column-width: $colWidth; height: $height">');
    return sb;
  }


  void lsCommand(String cmd, List<String> args) {
    void displayFiles(List<Entry> entry) {
      if (entry.length != 0) {

        StringBuffer html = formatColumns(entry);
        entry.forEach((file) {
          var fileType = file.isDirectory ? 'folder' : 'file';
          var span = '<span class="$fileType">${sanitizer.convert(file.name)}</span><br>';
          html.write(span);
        });

        html.write('</div>');
        writeOutput(html.toString());
      }
    };

    // Read contents of current working directory. According to spec, need to
    // keep calling readEntries() until length of result array is 0. We're
    // guarenteed the same entry won't be returned again.
    List<Entry> entries = [];
    DirectoryReader reader = cwd.createReader();

    void readEntries() {
      reader.readEntries()
      .then((List<Entry> results) {
        if (results.length == 0) {
          displayFiles(entries);
        } else {
          entries.addAll(results);
          readEntries();
        }
      }, onError: errorHandler);
    };

    readEntries();
  }

  void createDir(DirectoryEntry rootDirEntry, List<String> folders, [String createFromDir="", String cmd=""]) {
    if (folders.length == 0) {
      return;
    }

    if (createFromDir.isEmpty) {
      rootDirEntry.createDirectory(folders[0])
      .then((dirEntry) {
        // Recursively add the new subfolder if we still have a subfolder to create.
        if (folders.length != 0) {
          folders.removeAt(0);
          createDir(dirEntry, folders);
        }
      }, onError: errorHandler);
    } else {
      var fullPath = cwd.fullPath;
      cwd.getDirectory(createFromDir)
      .then((DirectoryEntry dirEntry) {
        cwd = dirEntry;
        // Create the folders
        createDir(cwd, folders);

        cwd.getDirectory(fullPath)
        .then((DirectoryEntry dirEntry) => cwd = dirEntry,
        onError: (FileError error) => invalidOpForEntryType(error, cmd, fullPath));
      }, onError: (FileError error) => invalidOpForEntryType(error, cmd, createFromDir));
    }
  }

  void mkdirCommand(String cmd, List<String> args) {
    var dashP = false;
    var index = args.indexOf('-p');
    if (index != -1) {
      args.removeAt(index);
      dashP = true;
    }

    if (args.length == 0) {
      writeOutput('usage: ${sanitizer.convert(cmd)} [-p] directory<br>');
      return;
    }

    // Create each directory passed as an argument.
    for (int i = 0; i < args.length; i++) {
      String dirName = args[i];

      if (dashP) {
        var folders = dirName.split('/');
        // Throw out './' or '/' if present on the beginning of our path.
        if (folders[0] == '.' || folders[0] == '') {
          folders.removeAt(0);
        }

        // If '/' is present then we change directories in createDir.
        if (dirName[0] == "/") {
          createDir(cwd, folders, dirName[0], cmd);
        } else {
          createDir(cwd, folders);
        }
      } else {
        cwd.createDirectory(dirName, exclusive: true)
        .then((_) {}, onError: (FileError error) {
          invalidOpForEntryType(error, cmd, dirName);
        });
      }
    }
  }

  void updateFilename(String cmd, List<String> args, Function action) {
    if (args.length != 2) {
      writeOutput('usage: ${sanitizer.convert(cmd)} source target<br>'
                  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sanitizer.convert(cmd)}'
                  ' source directory/');
      return;
    }

    String src = args[0];
    String dest = args[1];

    // Moving to a folder? (e.g. second arg ends in '/').
    if (dest[dest.length - 1].endsWith('/')) {
      cwd.getDirectory(src)
      .then((DirectoryEntry srcDirEntry) {
            // Create blacklist for dirs we can't re-create.
            var create = ['.', './', '..', '../', '/'].indexOf(dest) != -1 ? false : true;

            if (create) {
              cwd.createDirectory(dest)
              .then((DirectoryEntry destDirEntry) => action(srcDirEntry, destDirEntry),
              onError: errorHandler);
            } else {
              cwd.getDirectory(dest)
              .then((DirectoryEntry destDirEntry) => action(srcDirEntry, destDirEntry),
              onError: errorHandler);
            }
          }, onError: errorHandler);
    } else {
      // Treat src/destination as files.
      cwd.getFile(src).then((FileEntry srcFileEntry) {
            srcFileEntry.getParent()
            .then((DirectoryEntry parentDirEntry) => action(srcFileEntry, parentDirEntry, dest),
                onError: errorHandler);
          },
          onError: errorHandler);
    }
  }

  void cpCommand(String cmd, List<String> args) {
    updateFilename(cmd, args,
        (srcDirEntry, destDirEntry, [name = ""]) {
              if (name.isEmpty) {
                srcDirEntry.copyTo(destDirEntry);
              } else {
                srcDirEntry.copyTo(destDirEntry, name);
              }
            });
  }

  void mvCommand(String cmd, List<String> args) {
    updateFilename(cmd, args,
        (srcDirEntry, destDirEntry, [name = ""]) {
              if (name.isEmpty) {
                srcDirEntry.moveTo(destDirEntry);
              } else {
                srcDirEntry.moveTo(destDirEntry, name);
              }
            });
  }

  void openCommand(String cmd, List<String> args) {
    //var fileName = Strings.join(args, ' ').trim();
    if (args.length == 0) {
      writeOutput('usage: ${sanitizer.convert(cmd)} [filenames]');
      return;
    }

    args.forEach((fileName) {
      open(cmd, fileName, (FileEntry fileEntry) {
        window.open(fileEntry.toUrl(), '$fileName');
      });
    });
  }

  void open(String cmd, String path, successCallback) {

    cwd.getFile(path).then(successCallback, onError: (error) {
          if (error.code == FileError.NOT_FOUND_ERR) {
            writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(path)}: No such file or directory<br>');
          } else {
            errorHandler(error);
          }
        });
  }

  void pwdCommand(String cmd, List<String> args) {
    writeOutput(sanitizer.convert(cwd.fullPath));
  }

  void rmCommand(String cmd, List<String> args) {
    // Remove recursively? If so, remove the flag(s) from the arg list.
    var recursive = false;
    var switches = ['-r', '-f', '-rf', '-fr'];
    switches.forEach((sw) {
      var index = args.indexOf(sw);
      if (index != -1) {
        while (index != -1) {
          args.removeAt(index);
          index = args.indexOf(sw);
        }
        recursive = true;
      }
    });

    args.forEach((fileName) {
      cwd.getFile(fileName).then((fileEntry) {
            fileEntry.remove().then((_) {}, onError: errorHandler);
          },
          onError: (error) {
            if (recursive && error.code == FileError.TYPE_MISMATCH_ERR) {
              cwd.getDirectory(fileName)
              .then((DirectoryEntry dirEntry) => dirEntry.removeRecursively().then((_) {}, onError: errorHandler),
                  onError: errorHandler);
            } else if (error.code == FileError.INVALID_STATE_ERR) {
              writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(fileName)}: is a directory<br>');
            } else {
              errorHandler(error);
            }
          });
    });
  }

  void rmdirCommand(String cmd, List<String> args) {
    args.forEach((dirName) {
      cwd.getDirectory(dirName)
      .then((dirEntry) {
            dirEntry.remove().then((_) {}, onError: (error) {
              if (error.code == FileError.INVALID_MODIFICATION_ERR) {
                writeOutput('${sanitizer.convert(cmd)}: ${sanitizer.convert(dirName)}: Directory not empty<br>');
              } else {
                errorHandler(error);
              }
            });
          },
          onError: (error) => invalidOpForEntryType(error, cmd, dirName));
    });
  }

  void themeCommand(String cmd, List<String> args) {
    var theme = args.join(' ').trim();
    if (theme.isEmpty) {
      writeOutput('usage: ${sanitizer.convert(cmd)} ${sanitizer.convert(themes.toString())}');
    } else {
      if (themes.contains(theme)) {
        setTheme(theme);
      } else {
        writeOutput('Error - Unrecognized theme used');
      }
    }
  }

  void whoCommand(String cmd, List<String> args) {
    writeOutput('${sanitizer.convert(document.title)}'
                ' - By:  Eric Bidelman &lt;ericbidelman@chromium.org&gt;,'
                ' Adam Singer &lt;financeCoding@gmail.com&gt;');
  }

  void writeOutput(String h) {
    output.insertAdjacentHtml('beforeEnd', h);
  }
}
