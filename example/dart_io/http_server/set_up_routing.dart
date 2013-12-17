// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';

import 'package:route/server.dart';
import 'package:route/url_pattern.dart';

final postsUrl = new UrlPattern(r'/posts\/?');
final postUrl = new UrlPattern(r'/post/(\d+)\/?');

servePosts(req) {
  req.response.write("All blog posts");
  req.response.close();
}

servePost(req) {
  var postId = postUrl.parse(req.uri.path)[0];
  req.response.write('Blog post $postId');
  req.response.close();
}

serveNotFound(req) {
  req.response.statusCode = HttpStatus.NOT_FOUND;
  req.response.write('Not found');
  req.response.close();
}

void main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
    var router = new Router(server)
      ..serve(postsUrl, method: 'GET').listen(servePosts)
      ..serve(postUrl, method: 'GET').listen(servePost)
      ..defaultStream.listen(serveNotFound);
  });
}
