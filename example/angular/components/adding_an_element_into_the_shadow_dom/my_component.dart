// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library my_component;

import 'package:angular/angular.dart';
import 'dart:html';

@NgComponent(
    selector: 'my-component',
    templateUrl: './my_component.html',
    publishAs: 'cmp'
)
class MyComponent implements NgShadowRootAware {
  void onShadowRoot(ShadowRoot shadowRoot) {
    shadowRoot.querySelector('#myDiv').children.add(
      new ParagraphElement()..text = 'Dynamically added content'
    );
  }
}
