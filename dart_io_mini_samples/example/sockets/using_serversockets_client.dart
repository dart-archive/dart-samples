// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Create a new socket connection using `Socket.connect()`. Send data over the
/// socket using the Socket `write()` method.
///

import 'dart:io';

main() {
  Socket.connect('127.0.0.1', 4041).then((socket) {
    print(socket.runtimeType);
    socket.write('Hello, World!');
  });
}