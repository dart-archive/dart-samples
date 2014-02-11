library my_router;

import 'package:angular/angular.dart';

RouteInitializerFn myRouteInitializer = (Router router, ViewFactory view) {
  router.root
    ..addRoute(
        name: 'about',
        path: '/about',
        enter: view('views/about.html'))
    ..addRoute(
        name: 'bio',
        path: '/bio',
        enter: view('views/bio.html'));
};
