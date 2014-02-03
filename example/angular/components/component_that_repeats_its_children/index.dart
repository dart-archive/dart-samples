library main;

@MirrorsUsed(
    targets: const [MyComponent, NgBindNodesDirective],
    override: '*')
import 'dart:mirrors';

import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:di/di.dart';

class Item {
  String name;
  Item(this.name);
}

@NgDirective(
  selector: '[ng-bind-nodes]',
  publishAs: 'ctrlx' // conflicts with my-component
)
class NgBindNodesDirective {
  dom.Element _element;
  MyComponent _myComponent;
  Scope _scope;
  Compiler _compile;
  Injector _injector;

  NgBindNodesDirective(this._element, this._myComponent, this._scope, this._compile, this._injector);

  @NgOneWay('ng-bind-nodes') set nodes(var nodes) {
    print(nodes);
    if(nodes == null) {
      return;
    }
    _element.nodes.clear();
    nodes.forEach((dom.Node node) {
      _element.nodes.add(node.clone(true));
    });

    BlockFactory template = _compile(_element.nodes);
    Block block = template(_injector, _element.nodes);
  }
}


@NgComponent(
    selector: 'my-component',
    publishAs: 'ctrl',
    template: '''<div ng-repeat="value in ctrl.values"><span ng-bind-nodes="ctrl.nodes"></span><span>something hardcoded: {{value.name}}</span></div><content id='content'></content>'''
)

class MyComponent extends NgShadowRootAware {
  List<Item> values = [new Item('1'), new Item('2'), new Item('3'), new Item('4')];

  List<dom.Node> nodes = new List<dom.Node>();

  MyComponent();

  @override
  void onShadowRoot(dom.ShadowRoot shadowRoot) {
    nodes.addAll((shadowRoot.querySelector('#content') as dom.ContentElement).getDistributedNodes());
    //nodes.forEach((n) => print(n));
    nodes.forEach((n) => n.remove());
  }
}

class MyAppModule extends Module {
  MyAppModule() {
    type(MyComponent);
    type(NgBindNodesDirective);
  }
}

void main() {
  ngBootstrap(module: new MyAppModule());
}
