library my_router;

import 'package:angular/angular.dart';

RouteInitializerFn myRouteInitializer = (Router router, ViewFactory view) {
  router.root
  ..addRoute(
      name: 'book',
      path: '/book/:bookId',
      mount: (Route route) => route
      ..addRoute(
          name: 'show',
          path: '/show',
          enter: view('views/show_book.html')));
};
