// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library book_component;

import 'package:angular/angular.dart';
import 'book.dart' show Book;

@NgComponent(
    selector: 'book-component',
    templateUrl: './book_component.html',
    publishAs: 'cmp'
)
class BookComponent {
  @NgOneWay('book-map')
  Map<String, Book> bookMap;
  String _bookId;

  BookComponent(RouteProvider routeProvider) {
    _bookId = routeProvider.parameters['bookId'];
  }

  Book get book => bookMap[_bookId];
}
