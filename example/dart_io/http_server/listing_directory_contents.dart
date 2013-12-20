// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the http Pub package, and create a VirtualDirectory to serve the
/// request. Set the VirtualDirectory `allowDirectoryListing` field to
/// true. Requests to the default directory ('/') display the contents of that
/// directory.

library simple_http_server;

import 'dart:io';
import 'package:http_server/http_server.dart' show VirtualDirectory;

final MY_HTTP_ROOT_PATH = Platform.script.resolve('web').toFilePath();

void main() {
  var virDir = new VirtualDirectory(MY_HTTP_ROOT_PATH);
  virDir.allowDirectoryListing = true;

  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
    server.listen((request) {
      virDir.serveRequest(request);
    });
  });
}
