// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use `Platform.operatingSystem` to get the operating system as a String.
/// Or, use the `isMacOS`, `isAndroid`, `isLinux`, and `isWindows` static
/// getters defined in `Platform`.

import 'dart:io' show Platform, stdout;

void main() {
  // Get the operating system as a string.
  String os = Platform.operatingSystem;

  // Or, use predicate getters for checking the operating system.
  stdout.write("You are using ");
  if (Platform.isMacOS) {
    stdout.writeln('a Mac');
  } else if (Platform.isAndroid) {
    stdout.writeln('an Android device');
  } else if (Platform.isLinux) {
    stdout.writeln('Linux');
  } else if (Platform.isWindows) {
    stdout.writeln('Windows');
  } else {
    stdout.writeln('something other than MacOS, Android, Linux, or Windows');
  }
}