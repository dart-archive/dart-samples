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
  int histpos = 0;
  Map<String, Function> cmds;
  Function readEntries;
  
  Terminal(this.cmdLineContainer,this.outputContainer, this.cmdLineInput) {
    cmdLine = document.query(cmdLineContainer);
    output = document.query(outputContainer);
    input = document.query(cmdLineInput);
    cmds = {
                  'clear':clearCommand,
                  'help':helpCommand,
                  'version':versionCommand,       
                  'cat':catCommand,
                  'cd':cdCommand,
                  'date':dateCommand,
                  'ls':lsCommand,
                  'mkdir':mkdirCommand,
                  'mv':mvCommand,
                  'cp':mvCommand,
                  'open':openCommand,
                  'pwd':pwdCommand,
                  'rm':rmCommand,
                  'rmdir':rmdirCommand,
                  'theme':themeCommand,
                  'who':whoCommand
    };
    

    
    window.on.click.add((event) => cmdLine.focus());
    // Always force text cursor to end of input line.
   
    // Always force text cursor to end of input line.
    cmdLine.on.click.add((event) => input.value = input.value);
    
    // Handle up/down key presses for shell history and enter for new command.
    cmdLine.on.keyDown.add(historyHandler);
    cmdLine.on.keyDown.add(processNewCommand);
  }
  
  void historyHandler(KeyboardEvent event) {
    var histtemp = "";
    // historyHandler
    if (event.keyCode == 38 || event.keyCode == 40) {
      event.preventDefault();
      // up or down
      if (histpos < history.length) {
        history[histpos] = input.value;
      } else {
        histtemp = input.value;
      }
    }
    
    if (event.keyCode == 38) { // up
      histpos--;
      if (histpos < 0) {
        histpos = 0;
      }
    } else if (event.keyCode == 40) { // down
      histpos++;
      if (histpos >= history.length) {
        histpos = history.length - 1;
      }
    }
    
    if (event.keyCode == 38 || event.keyCode == 40) {
      // up or down
      input.value = history[histpos] != null ? history[histpos]  : histtemp; 
    }
  }
  
  void processNewCommand(KeyboardEvent event) {
    if (event.keyCode == 9) {
      event.preventDefault();
    } else if (event.keyCode == 13) { // enter
      
      if (input.value is String && !input.value.isEmpty) {
        history.add(input.value);
        histpos = history.length;
      }
      
      // move the line to output and remove id's
      DivElement line = input.parent.parent.clone(true);
      line.attributes.remove('id');
      line.classes.add('line');
      InputElement c = line.query(cmdLineInput);
      c.attributes.remove('id');
      c.autofocus = false;
      c.readOnly = true;
      output.elements.add(line);
      String cmdline = input.value;
      input.value = ""; // clear input
      
      // Parse out command, args, and trim off whitespace
      List<String> args;
      String cmd="";
      if (cmdline is String) {
        cmdline.trim();
        args = cmdline.split(' ');
        cmd = args[0].toLowerCase();
        args.removeRange(0, 1);
      }
      
      // function look up
      if (cmds[cmd] is Function) {
        cmds[cmd](cmd,args);
      } else {
        writeOutput('${cmd}: command not found');
      }
      
      window.scrollTo(0, window.innerHeight);  
    }
  }
    
  void initFS(bool persistent, int size) {
    writeOutput('<div>Welcome to ${document.title}'
                '! (v${version})</div>');
    writeOutput(new Date.now().toLocal().toString());
    writeOutput('<p>Documentation: type "help"</p>');
    
    var type = persistent ? LocalWindow.PERSISTENT : LocalWindow.TEMPORARY;
    window.webkitRequestFileSystem(type, 
        size, 
        filesystemCallback, 
        errorHandler);
  }
  
  void filesystemCallback(DOMFileSystem filesystem) {
    fs = filesystem;
    cwd = fs.root;
    
    // Attempt to create a folder to test if we can. 
    cwd.getDirectory('testquotaforfsfolder', 
        options: {'create': true},
        successCallback:  (DirectoryEntry dirEntry){
          dirEntry.remove(() {}); // If successfully created, just delete it.          
        },
        errorCallback: (error) {
          if (error.code == FileError.QUOTA_EXCEEDED_ERR) {
            writeOutput('ERROR: Write access to the FileSystem is unavailable. '
                   'Are you running Google Chrome with ' 
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
        msg = 'Unknown Error';
        break;
    };
    writeOutput('<div>Error: $msg </div>');
  }
  
  void invalidOpForEntryType(FileError error, String cmd, String dest) {
    if (error.code == FileError.NOT_FOUND_ERR) {
      writeOutput('$cmd: $dest: No such file or directory<br>');
    } else if (error.code == FileError.INVALID_STATE_ERR) {
      writeOutput('$cmd: $dest: Not a directory<br>');
    } else if (error.code == FileError.INVALID_MODIFICATION_ERR) {
      writeOutput('$cmd: $dest: File already exists<br>');
    } else {
      errorHandler(error);
    }
  }
  
  void setTheme([String theme='default']) {
    var currentUrl = window.location.pathname;
    
    if (theme == 'default') {
      // history.replaceState({}, '', currentUrl);
      window.localStorage.remove('theme');
      document.body.classes.clear();
      return;
    } else if (theme != null) {
      document.body.classes.add(theme);
      window.localStorage['theme'] = theme;
      //history.replaceState({}, '', currentUrl + '#theme=' + theme);
    }
  }
  
  void addDroppedFiles(List<File> files) {
    files.forEach((file) {
      cwd.getFile(file.name, 
          options: {'create': true, 'exclusive': true}, 
          successCallback: (FileEntry fileEntry) {
            fileEntry.createWriter((FileWriter fileWriter) {
              fileWriter.on.error.add((e)=>errorHandler(e));
              fileWriter.write(file);
            }, (error) => errorHandler(error));
          }, 
          errorCallback: (error) => errorHandler(error));
    });
  }
  
  void read(String cmd, String path, var callback) {
    if (fs == null) {
      return;
    }
    
    cwd.getFile(path, 
        options: {}, 
        successCallback: (FileEntry fileEntry) {
          fileEntry.file((file) {
            var reader = new FileReader();
            reader.on.loadEnd.add((ProgressEvent event)=>callback(reader.result));
            reader.readAsText(file);
          }, (error) => errorHandler(error));
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
    input.value = '';
  }
  
  void helpCommand(String cmd, List<String> args) {
    StringBuffer sb = new StringBuffer();
    sb.add('<div class="ls-files">');
    cmds.keys.forEach((key) => sb.add('${key}<br>'));
    sb.add('</div>');
    sb.add('<p>Add files by dragging them from your desktop.</p>');
    writeOutput(sb.toString());
  }
  
  void versionCommand(String cmd, List<String> args) {
    writeOutput("${version}");
  }
  
  void catCommand(String cmd, List<String> args) {
    if (args.length >= 1) {
      var fileName = args[0];      
      if (fileName is String) {
        read(cmd, fileName, (result) {
          writeOutput('<pre> ${result} </pre>');
        });
      } else {
        writeOutput('usage: ${cmd} filename');
      }
    } else {
      writeOutput('usage: ${cmd} filename');
    }
  }
  
  void cdCommand(String cmd, List<String> args) {
    args = args == null ? [""] : args;
    StringBuffer sb = new StringBuffer();
    sb.addAll(args);
    var dest = sb.toString();
    
    if (dest.isEmpty) {
      dest = '/';
    }
    
    cwd.getDirectory(dest, 
        options: {}, 
        successCallback: (DirectoryEntry dirEntry){ 
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
    
    if (fs == null) {
      return;
    }
    
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
          }, (error) => errorHandler(error));
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
        }, errorCallback: (error) => errorHandler(error));
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
            successCallback: (_){},
            errorCallback: (FileError error) {
              invalidOpForEntryType(error, cmd, dirName);
            });
      }
    }
  }
  
  void mvCommand(String cmd, List<String> args) {
    if (args.length != 2) {
      writeOutput('usage: $cmd source target<br>'
                  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$cmd'
                  ' source directory/');
      return;
    }
    
    String src = args[0];
    String dest = args[1];
    
    Function runAction = (c, srcDirEntry, destDirEntry, [opt_newName = null]) {
      String newName = "";
      if (opt_newName != null) { 
        newName = opt_newName;
      }
      
      if (c == 'mv') {
        srcDirEntry.moveTo(destDirEntry); 
      } else { // c=='cp'
        srcDirEntry.copyTo(destDirEntry);
      }
    };
    
    // Moving to a folder? (e.g. second arg ends in '/').
    if (dest[dest.length - 1] == '/') {
      cwd.getDirectory(src, 
          options: {}, 
          successCallback: (DirectoryEntry srcDirEntry){
            // Create blacklist for dirs we can't re-create.
            var create = ['.', './', '..', '../', '/'].indexOf(dest) != -1 ? false : true;
            
            cwd.getDirectory(dest, 
                options: {'create': create}, 
                successCallback: (DirectoryEntry destDirEntry) => runAction(cmd, srcDirEntry, destDirEntry), 
                errorCallback: (FileError error) => errorHandler(error));
          }, 
          errorCallback: (FileError error) => errorHandler(error));
    } else { // Treat src/destination as files.
      cwd.getFile(src, options: {}, 
          successCallback: (DirectoryEntry srcFileEntry) {
            srcFileEntry.getParent((DirectoryEntry parentDirEntry) => runAction(cmd, srcFileEntry, parentDirEntry, dest),
                (FileError error) => errorHandler(error));
          }, 
          errorCallback: (FileError error) => errorHandler(error));
    }
  }
  
  void openCommand(String cmd, List<String> args) {
    StringBuffer sb = new StringBuffer();
    sb.addAll(args);
    var fileName = sb.toString();
    
    if (fileName.isEmpty) {
      writeOutput('usage: $cmd filename');
      return;
    }
    
    open(cmd, fileName, (FileEntry fileEntry) {
      var myWin = window.open(fileEntry.toURL(), 'mywin');
    });
  }
  
  void open(String cmd, String path, successCallback) {
    if (fs == null) {
      return;
    }
    
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
            fileEntry.remove(() {}, (error) => errorHandler(error)); 
          }, 
          errorCallback: (error){
            if (recursive && error.code == FileError.TYPE_MISMATCH_ERR) {
              cwd.getDirectory(fileName, 
                  options:{}, 
                  successCallback: (DirectoryEntry dirEntry) => dirEntry.removeRecursively(() {}, (error) => errorHandler(error)), 
                  errorCallback: (error) => errorHandler(error));
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
            dirEntry.remove((){}, (error) {
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
    StringBuffer sb = new StringBuffer();
    sb.addAll(args);
    var theme = sb.toString();
    if (theme.isEmpty) {
      writeOutput('usage: $cmd ${themes}');
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
