// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the COPYING file.

// This is a port of "A Simple ToDo List Using HTML5 IndexedDB" to Dart.
// See: http://www.html5rocks.com/en/tutorials/indexeddb/todo/

import 'dart:html';

class TodoList {
  static final String _TODOS_DB = "todo";
  static final String _TODOS_STORE = "todos";

  IDBDatabase _db;
  int _version = 1;
  InputElement _input;
  Element _todoItems;

  TodoList() {
    _todoItems = query('#todo-items');
    _input = query('#todo');
    query('input#submit').on.click.add((e) => _onAddTodo());
  }

  void open() {
    var request = window.indexedDB.open(_TODOS_DB, _version);
    request.on.success.add((e) => _onDbOpened(request.result));
    request.on.error.add(_onError);
    request.on.upgradeNeeded.add((e) => _onUpgradeNeeded(request.transaction));
  }

  void _onError(e) {
    // Get the user's attention for the sake of this tutorial. (Of course we
    // would *never* use window.alert() in real life.)
    window.alert('Oh no! Something went wrong. See the console for details.');
    window.console.log('An error occurred: {$e}');
  }

  void _onDbOpened(IDBDatabase db) {
    _db = db;
    _getAllTodoItems();
  }

  void _onUpgradeNeeded(IDBTransaction changeVersionTransaction) {
    changeVersionTransaction.on.complete.add((e) => _getAllTodoItems());
    changeVersionTransaction.on.error.add(_onError);
    changeVersionTransaction.db.createObjectStore(_TODOS_STORE,
        {'keyPath': 'timeStamp'});
  }

  void _onAddTodo() {
    var value = _input.value.trim();
    if (value.length > 0) {
      _addTodo(value);
    }
    _input.value = '';
  }

  void _addTodo(String text) {
    var trans = _db.transaction(_TODOS_STORE, 'readwrite');
    var store = trans.objectStore(_TODOS_STORE);
    var request = store.put({
      'text': text,
      'timeStamp': new Date.now().millisecondsSinceEpoch.toString()
    });
    request.on.success.add((e) => _getAllTodoItems());
    request.on.error.add(_onError);
  }

  void _deleteTodo(String id) {
    var trans = _db.transaction(_TODOS_STORE, 'readwrite');
    var store =  trans.objectStore(_TODOS_STORE);
    var request = store.delete(id);
    request.on.success.add((e) => _getAllTodoItems());
    request.on.error.add(_onError);
  }

  void _getAllTodoItems() {
    _todoItems.nodes.clear();

    var trans = _db.transaction(_TODOS_STORE, 'readwrite');
    var store = trans.objectStore(_TODOS_STORE);

    // Get everything in the store.
    var request = store.openCursor();
    request.on.success.add((e) {
      var cursor = request.result;
      if (cursor != null && cursor.value != null) {
        _renderTodo(cursor.value);
        cursor.continueFunction();
      }
    });
    request.on.error.add(_onError);
  }

  void _renderTodo(Map todoItem) {
    var textDisplay = new Element.tag('span');
    textDisplay.text = todoItem['text'];

    var deleteControl = new Element.tag('a');
    deleteControl.text = '[Delete]';
    deleteControl.on.click.add((e) => _deleteTodo(todoItem['timeStamp']));

    var item = new Element.tag('li');
    item.nodes.add(textDisplay);
    item.nodes.add(deleteControl);
    _todoItems.nodes.add(item);
  }
}

void main() {
  new TodoList().open();
}
