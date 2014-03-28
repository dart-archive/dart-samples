// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the COPYING file.

// This is a port of "High DPI Canvas" to Dart.
// See: http://www.html5rocks.com/en/tutorials/canvas/hidpi/

import 'dart:html';

void drawImage(CanvasElement canvas, ImageElement image,
               {bool auto: true,
                srcX: 0,    srcY: 0,    srcW: null, srcH: null,
                desX: null, desY: null, desW: null, desH: null}) {

  if (srcW == null) srcW = image.naturalWidth;
  if (srcH == null) srcH = image.naturalHeight;
  if (desX == null) desX = srcX;
  if (desY == null) desY = srcY;
  if (desW == null) desW = srcW;
  if (desH == null) desH = srcH;

  CanvasRenderingContext2D context = canvas.getContext("2d");

  num devicePixelRatio = window.devicePixelRatio;
  num backingStoreRatio = context.backingStorePixelRatio;
  num ratio = devicePixelRatio / backingStoreRatio;

  if (auto && devicePixelRatio != backingStoreRatio) {
    num oldWidth = canvas.width;
    num oldHeight = canvas.height;

    canvas.width = (oldWidth * ratio).round();
    canvas.height = (oldHeight * ratio).round();

    canvas.style.width = "${oldWidth}px";
    canvas.style.height = "${oldHeight}px";

    context.scale(ratio, ratio);
  }

  context.drawImageScaledFromSource(image as CanvasImageSource, srcX, srcY, srcW, srcH, desX, desY, desW, desH);
}

void main() {
  CanvasElement canvas = querySelector("#canvas");
  ImageElement pic = querySelector("#pic");
  drawImage(canvas, pic, desX: 10, desY: 10, desW: 300, desH: 90);
}
