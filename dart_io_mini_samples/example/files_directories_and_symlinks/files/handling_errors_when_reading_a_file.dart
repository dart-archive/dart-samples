// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

void handleError(e) {
  print('There was a ${e.runtimeType} error');
  print(e.message);
}

main() async {
  final filename = 'non_existent_file.txt';
  try {
    var file = await new File(filename).readAsString();
  } catch(e) {
    handleError(e);    
  }
}