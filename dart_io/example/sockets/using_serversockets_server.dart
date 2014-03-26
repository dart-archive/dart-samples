// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use `ServerSocket.bind()` to bind to an address and a port.  Get the socket
/// from the ServerSocket and listen to it for the data.

import 'dart:io';
import 'dart:convert';

main() {
  ServerSocket.bind('127.0.0.1', 4041)
    .then((serverSocket) {
      print('connected');
      serverSocket.listen((socket) {
        socket.transform(UTF8.decoder).listen(print);
      });
    });
}