library main;

@MirrorsUsed(
    targets: const [MyAppModule, RowController, MyTrComponent],
    override: '*')
import 'dart:mirrors';

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:di/di.dart';

class Item {
  String name;
  Item(this.name);
}

@NgComponent(
    selector: 'tr[is=my-tr]',
    publishAs: 'ctrl',
    applyAuthorStyles: true,
    // use <span> instead of <td> because the browsers drop <td>' not inside a <table>.
    // <td>'s are created dynamically when the content is inserted into <tr>
    template: '''<content></content><span>{{ctrl.value.name}}</span><span> - </span><span>{{ctrl.value}}</span>'''
)
class MyTrComponent extends NgShadowRootAware{
  @NgTwoWay('param') Item value;

  MyTrComponent() {
    print('MyTrComponent');
  }

  @override
  void onShadowRoot(ShadowRoot shadowRoot) {
    // get content for table cells (ignore <content> and <style> tags)
    var templateElements = new List<Element>.from(shadowRoot.children.where((e) => !(e is StyleElement) && !(e is ContentElement)));

    // the table cells need to be put into the <content> element to become childs of the table row
    ContentElement ce = shadowRoot.querySelector('content');

    templateElements.forEach((span) {
      // remove from old place before adding to new parent
      span.remove();

      // get the content of a table cell (the future <td> content)
      var cellContent = new List<Node>.from(span.childNodes);

      // remove cell content from span before adding to the table cell
      cellContent.forEach((cc) => cc.remove());
      var td = new TableCellElement();

      cellContent.forEach((cc) => td.append(cc));

      ce.append(td);
    });
  }
}

@NgController(
  selector: "[ng-controller=row-ctrl]",
  publishAs: "ctrl",
  visibility: NgDirective.CHILDREN_VISIBILITY
)
class RowController {
  List<Item> values = [new Item('1'), new Item('2'), new Item('3'), new Item('4')];
  RowController() {
    print('RowController');
  }
}

class MyAppModule extends Module {
  MyAppModule() {
    type(MyTrComponent);
    type(RowController);
  }
}

void main() {
  ngBootstrap(module: new MyAppModule());
}
