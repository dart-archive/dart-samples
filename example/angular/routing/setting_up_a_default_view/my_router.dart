library my_router;

import 'package:angular/angular.dart';

class MyRouteInitializer implements RouteInitializer {
  init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
          name: 'hello',
          path: '/hello',
          enter: view('views/hello.html'))
      ..addRoute(
          name: 'default',
          path: '/default',
          defaultRoute: true,
          enter: view('views/default.html'));
  }
}
