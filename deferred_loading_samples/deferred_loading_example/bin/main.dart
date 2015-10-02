import 'package:deferred_loading_example/hello.dart' deferred as hello;

main() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
