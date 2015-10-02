// Copyright (c) 2013-2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the http Pub package, and create a VirtualDirectory to serve the
/// request. Register an error handler using the `errorHandler` property.

import 'dart:io';
import 'package:http_server/http_server.dart' as http_server;

errorPageHandler(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.NOT_FOUND
    ..write('Not found')
    ..close();
}

main() async {
  var buildPath = Platform.script.resolve('web').toFilePath();

  var virDir = new http_server.VirtualDirectory(buildPath)
    ..allowDirectoryListing = true
    ..errorPageHandler = errorPageHandler;

  var server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  await for (var request in server) virDir.serveRequest(request);
}
