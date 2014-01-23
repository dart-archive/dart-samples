// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library my_controller;

import 'package:angular/angular.dart';
import 'book.dart' show Book;

@NgController(
    selector: '[my-controller]',
    publishAs: 'ctrl'
)
class MyController implements NgDetachAware {
  RouteHandle route;
  String bookId;

  Map<String, Book> bookMap = {
    "1": new Book('War and Peace', 'A really long book'),
    "2": new Book('The Old Man and the Sea', 'A really short book')
  };

  MyController(RouteProvider router) {
    bookId = router.parameters['bookId'];
    route = router.route.newHandle();
  }

  detach() {
    route.discard();
  }
}