// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Exploring the FileSystem APIs" to Dart.
// See: http://www.html5rocks.com/en/tutorials/file/filesystem/

part of terminal_filesystem;

class Terminal {
  DOMFileSystem fs;
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
  Function readEntries;
  
  Terminal(this.cmdLineContainer, this.outputContainer, this.cmdLineInput) {
    cmdLine = document.query(cmdLineContainer);
    output = document.query(outputContainer);
    input = document.query(cmdLineInput);
    
    // Always force text cursor to end of input line.
    window.on.click.add((event) => cmdLine.focus());
    
    // Trick: Always force text cursor to end of input line.
    cmdLine.on.click.add((event) => input.value = input.value);
    
    // Handle up/down key presses for shell history and enter for new command.
    cmdLine.on.keyDown.add(historyHandler);
    cmdLine.on.keyDown.add(processNewCommand);
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
    
    if (event.keyCode == tabKey) { // Tab key
      event.preventDefault();
    } else if (event.keyCode == enterKey) { // Enter key
      
      if (!input.value.isEmpty) {
        history.add(input.value);
        historyPosition = history.length;
      }
      
      // Move the line to output and remove id's.
      DivElement line = input.parent.parent.clone(true);
      line.attributes.remove('id');
      line.classes.add('line');   
      InputElement cmdInput = line.query(cmdLineInput);
      cmdInput.attributes.remove('id');
      cmdInput.autofocus = false;
      cmdInput.readOnly = true;
      output.elements.add(line);
      String cmdline = input.value;
      input.value = ""; // clear input
      
      // Parse out command, args, and trim off whitespace.
      List<String> args;
      String cmd = "";
      if (!cmdline.isEmpty) {
        cmdline.trim();
        args = htmlEscape(cmdline).split(' ');
        cmd = args[0]; 
        args.removeRange(0, 1);
      }
      
      // Function look up
      if (cmds[cmd] is Function) {
        cmds[cmd](cmd, args);
      } else {
        writeOutput('$cmd: command not found');
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
    
    writeOutput('<div>Welcome to ${document.title}! (v$version)</div>');
    writeOutput(new Date.now().toLocal().toString());
    writeOutput('<p>Documentation: type "help"</p>');
    var type = persistent ? LocalWindow.PERSISTENT : LocalWindow.TEMPORARY;
    window.webkitRequestFileSystem(type, size, filesystemCallback, errorHandler);
  }
  
  void filesystemNotInitialized(String cmd, List<String> args) {
    writeOutput('<div>$cmd: not available since filesystem was not initialized</div>');
  }
  
  void filesystemCallback(DOMFileSystem filesystem) {
    fs = filesystem;
    
    if (fs is DOMFileSystem) {
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
    cwd.getDirectory('testquotaforfsfolder', 
        options: {'create': true},
        successCallback: (DirectoryEntry dirEntry) {
          dirEntry.remove(() {}); // If successfully created, just delete it.          
        },
        errorCallback: (error) {
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
    writeOutput('<div>Error: $msg</div>');
  }
  
  void invalidOpForEntryType(FileError error, String cmd, String dest) {
    switch (error.code) {
      case FileError.NOT_FOUND_ERR:
        writeOutput('$cmd: $dest: No such file or directory<br>');
        break;
      case FileError.INVALID_STATE_ERR:
        writeOutput('$cmd: $dest: Not a directory<br>');
        break;
      case FileError.INVALID_MODIFICATION_ERR:
        writeOutput('$cmd: $dest: File already exists<br>');
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
      cwd.getFile(file.name, 
          options: {'create': true, 'exclusive': true}, 
          successCallback: (FileEntry fileEntry) {
            fileEntry.createWriter((FileWriter fileWriter) {
              fileWriter.on.error.add(errorHandler);
              fileWriter.write(file);
            }, errorHandler);
          }, 
          errorCallback: errorHandler);
          //errorCallback: (error) => errorHandler(error));
    });
  }
  
  void read(String cmd, String path, var callback) {    
    cwd.getFile(path, 
        options: {}, 
        successCallback: (FileEntry fileEntry) {
          fileEntry.file((file) {
            var reader = new FileReader();
            reader.on.loadEnd.add((ProgressEvent event) => callback(reader.result));
            reader.readAsText(file);
          }, errorHandler);
        }, 
        errorCallback: (error) {
          if (error.code == FileError.INVALID_STATE_ERR) {
            writeOutput('$cmd: $path: is a directory<br>');
          } else if (error.code == FileError.NOT_FOUND_ERR) {
            writeOutput('$cmd: $path: No such file or directory<br>');
          } else {
            errorHandler(error);
          }
        });
  }
  
  void clearCommand(String cmd, List<String> args) {
    output.innerHTML = '';
  }
  
  void helpCommand(String cmd, List<String> args) {
    StringBuffer sb = new StringBuffer();
    sb.add('<div class="ls-files">');
    cmds.keys.forEach((key) => sb.add('$key<br>'));
    sb.add('</div>');
    sb.add('<p>Add files by dragging them from your desktop.</p>');
    writeOutput(sb.toString());
  }
  
  void versionCommand(String cmd, List<String> args) {
    writeOutput("$version");
  }
  
  void catCommand(String cmd, List<String> args) {
    if (args.length >= 1) {
      var fileName = args[0];
      read(cmd, fileName, (result) => writeOutput('<pre>$result</pre>'));
    } else {
      writeOutput('usage: $cmd filename');
    }
  }
  
  void cdCommand(String cmd, List<String> args) {
    var dest = Strings.join(args, ' ').trim();    
    if (dest.isEmpty) {
      dest = '/';
    }
    
    cwd.getDirectory(dest, 
        options: {}, 
        successCallback: (DirectoryEntry dirEntry) { 
          cwd = dirEntry;
          writeOutput('<div>${dirEntry.fullPath}</div>');
        },
        errorCallback: (FileError error) {
          invalidOpForEntryType(error, cmd, dest);
        });
  }
  
  void dateCommand(String cmd, var args) {
    writeOutput(new Date.now().toLocal().toString());
  }
  
  StringBuffer formatColumns(List<Entry> entries) {
    var maxName = entries[0].name;
    for (int i = 0; i<entries.length; i++) {
      if (entries[i].name.length > maxName.length) {
        maxName = entries[i].name;
      }
    }
    
    // If we have 3 or less entires, shorten the output container's height.
    // 15 is the pixel height with a monospace font-size of 12px;
    var height = entries.length <= 3 ? 'height: ${(entries.length * 15)}px;' : '';
        
    // 12px monospace font yields ~7px screen width.
    var colWidth = maxName.length * 7;

    StringBuffer sb = new StringBuffer();
    sb.addAll(['<div class="ls-files" style="-webkit-column-width:',
     colWidth, 'px;', height, '">']);
    return sb;
  }
  
  
  void lsCommand(String cmd, List<String> args) {
    Function success = (List<Entry> e) {
      if (e.length != 0) {
        
        StringBuffer html = formatColumns(e);
        for (int i = 0; i<e.length; i++) {
          html.addAll(['<span class="', e[i].isDirectory ? 'folder' : 'file','">', e[i].name, '</span><br>']);
        }
        html.add('</div>');
        writeOutput(html.toString());
      }
    };
    
    // Read contents of current working directory. According to spec, need to
    // keep calling readEntries() until length of result array is 0. We're
    // guarenteed the same entry won't be returned again.
    List<Entry> entries = [];
    DirectoryReader reader = cwd.createReader();
    readEntries = () {
      reader.readEntries(
          (List<Entry> results) {
            if (results.length == 0) {
              //entries.sort();
              success(entries);
            } else {
              entries.addAll(results);
              readEntries();
            }
          }, errorHandler);
    };
    
    readEntries();
  }
  
  void createDir(rootDirEntry, List<String> folders) {    
    if (folders.length == 0) {
      return;
    }
    
    rootDirEntry.getDirectory(folders[0], 
        options: {'create': true}, 
        successCallback: (dirEntry) {
          // Recursively add the new subfolder if we still have a subfolder to create.
          if (folders.length != 0) {
              folders.removeAt(0);
              createDir(dirEntry, folders);
          }
        }, errorCallback: errorHandler);
  }
  
  void mkdirCommand(String cmd, List<String> args) {
    var dashP = false;
    var index = args.indexOf('-p');
    if (index != -1) {
      args.removeAt(index);
      dashP = true;
    }
    
    if (args.length == 0) {
      writeOutput('usage: $cmd [-p] directory<br>');
      return;
    }
    
    // Create each directory passed as an argument.
    for(int i=0; i<args.length; i++) {
      String dirName = args[i];
      
      if (dashP) {
        var folders = dirName.split('/');
        // Throw out './' or '/' if present on the beginning of our path.
        if (folders[0] == '.' || folders[0] == '') {
          folders.removeAt(0);
        }
        
        createDir(cwd, folders);
      } else {
        cwd.getDirectory(dirName, 
            options: {'create': true, 'exclusive': true}, 
            successCallback: (_) {},
            errorCallback: (FileError error) {
              invalidOpForEntryType(error, cmd, dirName);
            });
      }
    }
  }
  
  void updateFilename(String cmd, List<String> args, Function action) {
    if (args.length != 2) {
      writeOutput('usage: $cmd source target<br>'
                  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$cmd'
                  ' source directory/');
      return;
    }
    
    String src = args[0];
    String dest = args[1];
    
    // Moving to a folder? (e.g. second arg ends in '/').
    if (dest[dest.length - 1] == '/') {
      cwd.getDirectory(src, 
          options: {}, 
          successCallback: (DirectoryEntry srcDirEntry) {
            // Create blacklist for dirs we can't re-create.
            var create = ['.', './', '..', '../', '/'].indexOf(dest) != -1 ? false : true;
            
            cwd.getDirectory(dest, 
                options: {'create': create}, 
                successCallback: (DirectoryEntry destDirEntry) => action(srcDirEntry, destDirEntry), 
                errorCallback: errorHandler);
          }, 
          errorCallback: errorHandler);
    } else { // Treat src/destination as files.
      cwd.getFile(src, options: {}, 
          successCallback: (FileEntry srcFileEntry) {
            srcFileEntry.getParent((DirectoryEntry parentDirEntry) => action(srcFileEntry, parentDirEntry, dest),
                errorHandler);
          }, 
          errorCallback: errorHandler);
    }
  }

  void cpCommand(String cmd, List<String> args) {
    updateFilename(cmd, args, (srcDirEntry, destDirEntry, [name=""]) => name.isEmpty ? srcDirEntry.copyTo(destDirEntry) : srcDirEntry.copyTo(destDirEntry, name));
  }
  
  void mvCommand(String cmd, List<String> args) {
    updateFilename(cmd, args, (srcDirEntry, destDirEntry, [name=""]) => name.isEmpty ? srcDirEntry.moveTo(destDirEntry) : srcDirEntry.moveTo(destDirEntry, name));
  }
  
  void openCommand(String cmd, List<String> args) {
    var fileName = Strings.join(args, ' ').trim();
    if (fileName.isEmpty) {
      writeOutput('usage: $cmd filename');
      return;
    }
    
    open(cmd, fileName, (FileEntry fileEntry) {
      var myWin = window.open(fileEntry.toURL(), 'mywin');
    });
  }
  
  void open(String cmd, String path, successCallback) {    
    cwd.getFile(path, 
        options: {}, 
        successCallback: successCallback, 
        errorCallback: (error) {
          if (error.code == FileError.NOT_FOUND_ERR) {
            writeOutput('$cmd: $path: No such file or directory<br>');
          } else {
            errorHandler(error);
          }
        });
  }
  
  void pwdCommand(String cmd, List<String> args) {
    writeOutput(cwd.fullPath);
  }
  
  void rmCommand(String cmd, List<String> args) {
    // Remove recursively? If so, remove the flag(s) from the arg list.
    var recursive = false;
    ['-r', '-f', '-rf', '-fr'].forEach((arg) {
      var index = args.indexOf(arg);
      if (index != -1) {
        args.removeAt(index);
        recursive = true;
      }
    });
    
    args.forEach((fileName) {
      cwd.getFile(fileName, options: {}, 
          successCallback: (fileEntry) {
            fileEntry.remove(() {}, errorHandler); 
          }, 
          errorCallback: (error) {
            if (recursive && error.code == FileError.TYPE_MISMATCH_ERR) {
              cwd.getDirectory(fileName, 
                  options:{}, 
                  successCallback: (DirectoryEntry dirEntry) => dirEntry.removeRecursively(() {}, errorHandler), 
                  errorCallback: errorHandler);
            } else if (error.code == FileError.INVALID_STATE_ERR) {
              writeOutput('$cmd: $fileName: is a directory<br>');
            } else {
              errorHandler(error);
            }
          });
    });
  }
  
  void rmdirCommand(String cmd, List<String> args) {
    args.forEach((dirName) {
      cwd.getDirectory(dirName, 
          options: {}, 
          successCallback: (dirEntry) {
            dirEntry.remove(() {}, (error) {
              if (error.code == FileError.INVALID_MODIFICATION_ERR) {
                writeOutput('$cmd: $dirName: Directory not empty<br>');
              } else {
                errorHandler(error);
              }
            }); 
          }, 
          errorCallback: (error) => invalidOpForEntryType(error, cmd, dirName));
    });
  }
  
  void themeCommand(String cmd, List<String> args) {
    var theme = Strings.join(args, ' ').trim();
    if (theme.isEmpty) {
      writeOutput('usage: $cmd $themes');
    } else {
      if (themes.contains(theme)) {
        setTheme(theme);
      } else {
        writeOutput('Error - Unrecognized theme used');
      }
    }
  }
  
  void whoCommand(String cmd, List<String> args) {
    writeOutput('${document.title}'
    ' - By:  Eric Bidelman &lt;ericbidelman@chromium.org&gt;, Adam Singer &lt;financeCoding@gmail.com&gt;');
  }
  
  void writeOutput(String h) {
    output.insertAdjacentHTML('beforeEnd', h);
  }
}
