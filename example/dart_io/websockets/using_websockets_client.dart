// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Make a WebSocket connection using `WebSocket.connect()`, and send data
/// over that connection using the WebSocket `add()` method.

import 'dart:io';

main() {
  WebSocket.connect('ws://127.0.0.1:4040/ws').then((socket) {
    socket.add('Hello, World!');
  });
}