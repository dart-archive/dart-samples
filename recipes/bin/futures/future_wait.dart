import 'dart:async';
import 'dart:io';

void main() {
  List<String> filenames = ['AUTHORS', 'README.md', 'LICENSEsadf'];
  List<File> files = filenames.map((filename) => new File(filename)).toList();

  Future.wait(files.map((file) => file.readAsString()).toList())
    .then((contents) {
      print("${contents.join('').length} characters read");
    })
    .catchError((error) {
      print('Encountered an ${error.runtimeType}. '
            'Check to make sure that the files exist. '
            'Also make sure that you have read permissions');
    });
}