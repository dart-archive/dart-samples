/// Use the Link `create()` method to create a symlink.

import 'dart:io';

main() async {
  // Get the system temp directory.
  var temp = await Directory.systemTemp.createTemp('my_temp_dir');

  // Generate a couple of paths.
  var first = '${temp.path}${Platform.pathSeparator}first';
  var second = '${temp.path}${Platform.pathSeparator}second';

  // Create a symlink.
  Link symLink = await new Link(second).create(first);
  print(symLink);
}
