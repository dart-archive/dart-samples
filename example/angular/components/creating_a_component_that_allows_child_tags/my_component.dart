// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library my_component;

import 'package:angular/angular.dart';

@NgComponent(
    selector: 'my-component',
    templateUrl: './my_component.html',
    publishAs: 'cmp'
)
class MyComponent {
  String greeting = 'Hello';
}
