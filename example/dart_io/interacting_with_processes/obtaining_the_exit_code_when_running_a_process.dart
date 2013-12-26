/// Use `Process.start()` to start a process to run an executable. This function
/// returns a new process that you can use to interact with the original
/// process. You can use this returned process to obtain the exit code from
/// executing the original process.

import 'dart:io';

main() {
  Process.start('ls', ['-l']).then((process) {
    // Get the exit code from the new process.
    process.exitCode.then((exitCode) {
      print('exit code: $exitCode'); // Prints 'exit code: 1'.
    });
  });
}