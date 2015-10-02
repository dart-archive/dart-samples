// Copyright (c) 2013-2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the http Pub package, and create a VirtualDirectory to serve the
/// request. Register a callback for handling errors using the `errorHandler`
/// property.

library simple_http_server;

import 'dart:io';
import 'package:http_server/http_server.dart' show VirtualDirectory;

VirtualDirectory virDir;

directoryHandler(dir, request) {
  var indexUri = new Uri.file(dir.path).resolve('index.html');
  virDir.serveFile(new File(indexUri.toFilePath()), request);
}

main() async {
  virDir = new VirtualDirectory(Platform.script.resolve('web').toFilePath())
    ..allowDirectoryListing = true
    ..directoryHandler = directoryHandler;

  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  await for (var request in server) virDir.serveRequest(request);
}
