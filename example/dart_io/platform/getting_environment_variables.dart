// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use `Platform.environment` to get the environment for the current process.

import 'dart:io' show Platform;

void main() {
  Map<String, String> envVars = Platform.environment;
  print(envVars['PATH']);
}