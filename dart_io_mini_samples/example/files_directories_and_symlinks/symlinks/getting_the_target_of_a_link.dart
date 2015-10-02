/// Use the Link `target()` method to get the path that the link points to.

import 'dart:async';
import 'dart:io';

// Creates temporary directory inside the system temp directory, creates a
// couple of paths in the created directory, and creates a symlink.
Future<Link> createSymLink() async {
  var temp = await Directory.systemTemp.createTemp('my_temp_dir');
  var first = '${temp.path}${Platform.pathSeparator}first';
  var second = '${temp.path}${Platform.pathSeparator}second';
  return new Link(second).create(first);
}

main() async {
  try {
    var link = await createSymLink();
    print(link.path);
    var targetPath = await link.target();
    print(targetPath);
  } catch (e) {
    print(e.message);
  }
}
