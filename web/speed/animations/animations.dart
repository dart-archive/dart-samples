// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Leaner, Meaner, Faster Animations with
// requestAnimationFrame" to Dart.
// See: http://www.html5rocks.com/en/tutorials/speed/animations/

import 'dart:html';

class AnimationExample {
  final _numMovers = 500;
  List<Element> _movers;
  List<num> _moverTops;
  num _lastScrollY = 0;
  bool _ticking = false;

  AnimationExample() {
    _movers = new List<Element>(_numMovers);
    _moverTops = new List<num>(_numMovers);
    for (var i = 0; i < _numMovers; i++) {
      var mover = new Element.tag("div");
      mover.classes.add("mover");
      mover.style.top = "${i * 10}px";
      document.body.nodes.add(mover);
      _movers[i] = mover;
    }
    window.onScroll.listen((e) => _onScroll());
  }

  void _onScroll() {
    _lastScrollY = window.scrollY;
    _requestTick();
  }

  void _requestTick() {
    if (!_ticking) {
      window.requestAnimationFrame(_update);
      _ticking = true;
    }
  }

  void _update(num time) {
    var halfWindowHeight = window.innerHeight * 0.5;
    var offset = 0;

    for (var i = 0; i < _movers.length; i++) {
      Element mover = _movers[i];
      _moverTops[i] = mover.offsetTop;
    }

    // Using separate for loops is a subtle browser optimization. See the
    // tutorial.
    for (var i = 0; i < _movers.length; i++) {
      Element mover = _movers[i];
      if (_lastScrollY > _moverTops[i] - halfWindowHeight) {
        mover.classes.add('left');
      } else {
        mover.classes.remove('left');
      }
    }

    _ticking = false;
  }
}

void main() {
  new AnimationExample();
}