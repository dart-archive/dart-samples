/// Use `Process.run()` to run a process. The results of the process are
/// returned asynchronously using a ProcessResult object.

import 'dart:io';

main() {
  // List all files in the current directory in UNIX-like operating systems.
  Process.run('ls', ['-l']).then((ProcessResult results) {
    print(results.stdout);
  });
}