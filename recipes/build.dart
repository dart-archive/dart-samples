import 'packages/web_ui/component_build.dart';
import 'dart:io';

void main() {
  build(new Options().arguments, [
      'web/webui/inject-expression/main.html',
      'web/webui/one-way-data-binding/main.html',
      'web/webui/text-binding/main.html',
      'web/webui/radio-binding/main.html',
      'web/webui/multiple-checkbox-binding/main.html',
      'web/webui/multiple-checkbox-binding-with-class/main.html',
      'web/webui/select-binding/main.html',
      'web/webui/list-binding/main.html'
      ]);
}


