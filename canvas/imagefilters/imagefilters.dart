// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the COPYING file.

// This is a port of "Image Filters with Canvas" to Dart.
// See: http://www.html5rocks.com/en/tutorials/canvas/imagefilters/


#import('dart:html');

class Filters {
  ImageData pixels;

  Filters(ImageElement img) {
    pixels = getPixels(img);
  }

  ImageData getPixels(ImageElement img) {
    CanvasElement canvas = new CanvasElement(img.width, img.height);
    CanvasRenderingContext2D context = canvas.getContext('2d');
    context.drawImage(img, 0, 0);
    return context.getImageData(0, 0, canvas.width, canvas.height);
  }

  ImageData grayscale() {
    var d = pixels.data;
    for (var i = 0; i < d.length; i += 4) {
      var r = d[i];
      var g = d[i+1];
      var b = d[i+2];
      // CIE luminance for the RGB
      var v = (0.2126 * r).toInt() + (0.7152 * g).toInt() + (0.0722 * b).toInt();
      d[i] = d[i + 1] = d[i + 2] = v;
    }
    return pixels;
  }

  ImageData brightness(int brightAdj) {
    var d = pixels.data;
    for (var i=0; i<d.length; i+=4) {
      d[i] += brightAdj;
      d[i + 1] += brightAdj;
      d[i + 2] += brightAdj;
    }
    return pixels;
  }

  ImageData threshold(int thresholdVal) {
    var d = pixels.data;
    for (var i = 0; i < d.length; i += 4) {
      var r = d[i];
      var g = d[i + 1];
      var b = d[i + 2];
      var v = (0.2126 * r + 0.7152 * g + 0.0722 * b >= thresholdVal) ? 255 : 0;
      d[i] = d[i + 1] = d[i + 2] = v;
    }
    return pixels;
  }
}

void main() {

  final brightAdj = 40;
  final thresholdVal = 128;

  ImageElement img = query('.orig');
  window.on.load.add((e) => populateImages(img));

  // Click listener for grayscale.
  document.query('[name = "grayscale"]').on.click.add((e) {
    if (query('#grayscale').previousElementSibling.style.display == 'none') {
      restoreContent('grayscale');
    } else {
      ImageData pixels = new Filters(img).grayscale();
      filterImage('grayscale', pixels);
    }
  });

  // Click listener for brightness.
  document.query('[name = "brightness"]').on.click.add((e) {
    if (query('#brightness').previousElementSibling.style.display == 'none') {
      restoreContent('brightness');
    } else {
      ImageData pixels = new Filters(img).brightness(brightAdj);
      filterImage('brightness', pixels);
    }
  });

  // Click listener for threshold.
  document.query('[name = "threshold"]').on.click.add((e) {
    if (query('#threshold').previousElementSibling.style.display == 'none') {
      restoreContent('threshold');
    } else {
      ImageData pixels = new Filters(img).threshold(thresholdVal);
      filterImage('threshold', pixels);
    }
  });
}

// Add copies of the original image to each canvas element.
void populateImages(ImageElement img) {
  var canvases = queryAll('canvas');
  for(var i = 0; i < canvases.length; i++) {
    CanvasElement c = canvases[i];
    c.parent.insertBefore(img.clone(true), c);
    c.style.display = 'none';
  }
}

// Put the filtered image back to its original (prefiltered) condition.
void restoreContent(String id) {
  CanvasElement canvas = query('#$id');
  var s = canvas.previousElementSibling.style;
  var b = canvas.parent.query('button');
  s.display = 'inline';
  canvas.style.display = 'none';
  b.innerHTML = 'apply $id filter';
}

// Show the filtered image.
void filterImage(String id, ImageData pixels) {
  CanvasElement canvas = query('#$id');
  var s = canvas.previousElementSibling.style;
  var b = canvas.parent.query('button');
  canvas.width = pixels.width;
  canvas.height = pixels.height;
  CanvasRenderingContext2D context = canvas.getContext('2d');
  context.putImageData(pixels, 0, 0);
  s.display = 'none';
  canvas.style.display = 'inline';
  b.innerHTML = 'restore original image';
}
