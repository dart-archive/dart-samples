import 'package:web_ui/component_build.dart';
import 'dart:io';

void main() {
  build(new Options().arguments, ['web/web_ui/one_way_data_binding/main.html']);
  build(new Options().arguments, ['web/web_ui/one_way_data_binding_with_watcher/main.html']);
  build(new Options().arguments, ['web/web_ui/two_way_data_binding/main.html']);
  build(new Options().arguments, ['web/web_ui/conditionals_and_loops/main.html']);
}