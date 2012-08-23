// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "HTML5 VIDEO" to Dart.
// See: http://www.html5rocks.com/en/tutorials/video/basics/

// XXX: This is currently broken because VideoElement.on does not have all events.
// See: http://code.google.com/p/dart/issues/detail?id=4628
//
// XXX: Once the above is fixed, switch from setInterval to requestAnimationFrame.

#import('dart:html');

class VideoExample {
  VideoElement _videoDom;
  CanvasElement _canvasCopy;
  CanvasElement _canvasDraw;
  var _ctxCopy, _ctxDraw;
  
  const _outPadding = 100;
  const _slices = 4;
  
  VideoExample() {
    var offsets = <int>[];
    var inertias = <num>[];
    var inertia = -2.0;
    int interval;
    
    _videoDom = query('#video-canvas-fancy');
    _canvasCopy = query('#canvas-copy-fancy');
    _canvasDraw = query('#canvas-draw-fancy');

    for (var i = 0; i < _slices; i++) {
      offsets.add(0);
      inertias.add(inertia);
      inertia += 0.4;
    }

    _videoDom.on.canPlay.add((e) => _onCanPlay, false);
    _videoDom.on.play.add((e) => _onPlay, false);
    _videoDom.on.pause.add((e) => _clearInterval, false);
    _videoDom.on.ended.add((e) => _clearInterval, false);
  }
  
  void _onCanPlay() {
    _canvasCopy.width = _canvasDraw.width = _videoDom.videoWidth;
    _canvasCopy.height = _videoDom.videoHeight;
    _canvasDraw.height = _videoDom.videoHeight + _outPadding;
    _ctxCopy = _canvasCopy.context2d;
    _ctxDraw = _canvasDraw.context2d;
  }
  
  void _onPlay() {
    _processEffectFrame();
    if (interval == null) {
      // XXX: Switch to requestAnimationFrame.
      interval = window.setInterval(_processEffectFrame, 33);
    }
  }
  
  void _processEffectFrame() {
    var sliceWidth = _videoDom.videoWidth / _slices;
    _ctxCopy.drawImage(_videoDom, 0, 0);
    _ctxDraw.clearRect(0, 0, _canvasDraw.width, _canvasDraw.height);
    for (var i = 0; i < _slices; i++) {
      var sx = i * sliceWidth;
      var sy = 0;
      var sw = sliceWidth;
      var sh = _videoDom.videoHeight;
      var dx = sx;
      var dy = offsets[i] + sy + _outPadding;
      var dw = sw;
      var dh = sh;
      _ctxDraw.drawImage(_canvasCopy, sx, sy, sw, sh, dx, dy, dw, dh);
      if ((offsets[i] + inertias[i]).abs() < _outPadding) {
        offsets[i] += inertias[i];
      } else {
        inertias[i] = -inertias[i];
      }
    }
  }
  
  void _clearInterval() {
    window.clearInterval(_interval);
    _interval = null;
  }
}

void main() {
  new VideoExample();
}