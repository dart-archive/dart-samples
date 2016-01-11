// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Upgrade a regular HTTP request to a WebSocket request using
/// `WebSocketTransformer.upgrade()`.

import 'dart:io';

handleMsg(msg) {
  print('Message received: $msg');
}

main() async {
  try {
    var server = await HttpServer.bind('127.0.0.1', 4040);
    await for (HttpRequest req in server) {
      if (req.uri.path == '/ws') {
        // Upgrade an HttpRequest to a WebSocket connection.
        var socket = await WebSocketTransformer.upgrade(req);
        socket.listen(handleMsg);
      }
    }
  } catch (e) {
    print(e);
  }
}
