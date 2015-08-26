import 'dart:html';

import "package:lazyloader/breakfast.dart" deferred as breakfast;
import "package:lazyloader/lunch.dart" deferred as lunch;
import "package:lazyloader/dinner.dart" deferred as dinner;

main() {
  querySelector('#show-breakfast').onClick.listen((_) async {
    await breakfast.loadLibrary();
    onBreakfastLoaded();
  });
  querySelector('#show-lunch').onClick.listen((_) async {
    await lunch.loadLibrary();
    onLunchLoaded();
  });
  querySelector('#show-dinner').onClick.listen((_) async {
    await dinner.loadLibrary();
    onDinnerLoaded();
  });
}

onBreakfastLoaded() {
  print('breakfast loaded');
  changeMenu(breakfast.menu);
}

onLunchLoaded() {
  print('lunch loaded');
  changeMenu(lunch.menu);
}

onDinnerLoaded() {
  print('dinner loaded');
  changeMenu(dinner.menu);
}

changeMenu(String menu) {
  var el = querySelector("#text_id");
  el.text = menu;
}
