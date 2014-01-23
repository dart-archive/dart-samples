// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library my_controller;

import 'package:angular/angular.dart';

class Book {
  String title, description;
  Book(this.title, this.description);
}

@NgController(
    selector: '[my-controller]',
    publishAs: 'ctrl'
)
class MyController {
  MyController(NgRoutingHelper locationService) {
    Router router = locationService.router;
    router.onRouteStart.listen((RouteStartEvent e) {
      e.completed.then((_) {
        if ('${e.uri}' == '/about') {
          router.go('bio', {});
        }
      });
    });
  }
}