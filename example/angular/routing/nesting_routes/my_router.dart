library my_router;

import 'package:angular/angular.dart';

class MyRouteInitializer implements RouteInitializer {
  init(Router router, ViewFactory view) {
    router.root
      ..addRoute(
          name: 'articles',
          path: '/articles',
          mount: (Route route) => route
            ..addRoute(
                name: 'all',
                path: '/all',
                enter: view('views/all_articles.html'))
            ..addRoute(
                name: 'featured',
                path: '/featured',
                enter: view('views/featured_article.html')));
  }
}