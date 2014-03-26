// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the COPYING file.

// This is a port of "Image Filters with Canvas" to Dart.
// See: http://www.html5rocks.com/en/tutorials/canvas/imagefilters/


import 'dart:html';
import 'dart:math';
import 'dart:typed_data';

class Filters {
  ImageData pixels;

  Filters(ImageElement img) {
    pixels = getPixels(img);
  }

  // Get image pixels from image element.
  ImageData getPixels(ImageElement img) {
    var canvas = new CanvasElement(width: img.width, height: img.height);
    CanvasRenderingContext2D context = canvas.getContext('2d');
    context.drawImage(img, 0, 0);
    return context.getImageData(0, 0, canvas.width, canvas.height);
  }

  // Create a temporary canvas to apply the filter to.
  ImageData createTempCanvas(int width, int height) {
    var tempCanvas = new CanvasElement(width: width, height: height);
    CanvasRenderingContext2D tempContext = tempCanvas.getContext('2d');
    return tempContext.createImageData(width, height);
  }

  // Apply grayscale filter.
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

  // Apply brightness filter.
  ImageData brightness(int brightAdj) {
    var d = pixels.data;
    for (var i=0; i<d.length; i+=4) {
      d[i] += brightAdj;
      d[i + 1] += brightAdj;
      d[i + 2] += brightAdj;
    }
    return pixels;
  }

  // Apply threshold filter.
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

  // Apply convolution filter.
  ImageData convolve(List weights, [bool opaque = false]) {
    var alphaFac = opaque ? 1 : 0;
    var side = (sqrt(weights.length).toInt());
    var halfSide = side ~/ 2;

    var d = pixels.data;
    var width = pixels.width;
    var height = pixels.height;

    var output = createTempCanvas(width, height);
    var dest = output.data;

    //Loop over the image.
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var r = 0.0, g = 0.0, b = 0.0, a = 0.0;
        var destOff = (y * width + x) * 4;
        //Now loop over the filter mask.
        for (var fy = 0; fy < side; fy++) {
          for (var fx = 0; fx < side; fx++) {
            var srcy = min(height - 1, max(0, y + fy - halfSide));
            var srcx = min(width - 1, max(0, x + fx - halfSide));
            var srcOff = (srcy * width + srcx) * 4;
            var weight = weights[(fy * side + fx)];
            r += d[srcOff] * weight;
            g += d[srcOff + 1] * weight;
            b += d[srcOff + 2] * weight;
            a += d[srcOff + 3] * weight;
          }
        }
        dest[destOff] = r.toInt();
        dest[destOff + 1] = g.toInt();
        dest[destOff + 2] = b.toInt();
        dest[destOff + 3] = (a + alphaFac * (255 - a)).toInt();
      }
    }
    return output;
  }

  // Apply Sobel filter.
  ImageData sobel(List hWeights, List vWeights) {
    var grayPixels = grayscale();
    var vpixels = convolveFloat32(grayPixels, vWeights);
    var hpixels = convolveFloat32(grayPixels, hWeights);

    var id = createTempCanvas(vpixels.width, vpixels.height);

    for (var i = 0; i < id.data.length; i += 4) {
      var v = vpixels.data[i].abs();
      id.data[i] = v.toInt();
      var h = hpixels.data[i].abs();
      id.data[i + 1] = h.toInt();
      id.data[i + 2] = ((v + h) / 4).toInt();
      id.data[i + 3] = 255;
    }
    return id;
  }

  // Apply convolution filter and return data as a double array.
  ImageDataFloat32 convolveFloat32(ImageData pixels, List weights, {bool opaque: false}) {
    var alphaFac = opaque ? 1 : 0;
    var side = (sqrt(weights.length).toInt());
    var halfSide = side ~/ 2;

    var d = pixels.data;
    var width = pixels.width;
    var height = pixels.height;

    //Create data structure to store the filtered data of type double.
    var output =
        new ImageDataFloat32(new Float32List(width * height * 4), width, height);
    var dest = output.data;

    //Loop over the image.
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var r = 0.0, g = 0.0, b = 0.0, a = 0.0;
        var destOff = (y * width + x) * 4;
        //Now loop over the filter mask.
        for (var fy = 0; fy < side; fy++) {
          for (var fx = 0; fx < side; fx++) {
            var srcy = min(height - 1, max(0, y + fy - halfSide));
            var srcx = min(width - 1, max(0, x + fx - halfSide));
            var srcOff = (srcy * width + srcx) * 4;
            var weight = weights[(fy * side + fx)];
            r += d[srcOff] * weight;
            g += d[srcOff + 1] * weight;
            b += d[srcOff + 2] * weight;
            a += d[srcOff + 3] * weight;
          }
        }
        dest[destOff] = r;
        dest[destOff + 1] = g;
        dest[destOff + 2] = b;
        dest[destOff + 3] = (a + alphaFac * (255 - a));
      }
    }
    return output;
  }
}

// Create a class to hold image data in a 32 bit float array.
class ImageDataFloat32 {
  final Float32List data;
  final width, height;

  ImageDataFloat32(this.data, this.width, this.height);
}

void main() {

  final brightAdj = 40;
  final thresholdVal = 128;
  final sharpenMask = [0, -1, 0,
                       -1, 5, -1,
                       0, -1, 0];
  final blurMask = [1/9, 1/9, 1/9,
                    1/9, 1/9, 1/9,
                    1/9, 1/9, 1/9];
  final hSobelMask = [-1, 0, 1,
                      -2, 0, 2,
                      -1, 0, 1];
  final vSobelMask = [-1,-2,-1,
                      0, 0, 0,
                      1, 2, 1];

  var img = querySelector('.orig');
  window.onLoad.listen((e) => populateImages(img));

  // Click listener for grayscale.
  querySelector('[name = "grayscale"]').onClick.listen(
      (e) => toggleFilter('grayscale',
          () => new Filters(img).grayscale()));
  // Click listener for brightness.
  querySelector('[name = "brightness"]').onClick.listen(
      (e) => toggleFilter('brightness',
          () => new Filters(img).brightness(brightAdj)));
  // Click listener for threshold.
  querySelector('[name = "threshold"]').onClick.listen(
      (e) => toggleFilter('threshold',
          () => new Filters(img).threshold(thresholdVal)));
  // Click listener for sharpen.
  querySelector('[name = "sharpen"]').onClick.listen(
      (e) => toggleFilter('sharpen',
          () => new Filters(img).convolve(sharpenMask)));
  // Click listener for blur.
  querySelector('[name = "blur"]').onClick.listen(
      (e) => toggleFilter('blur',
          () => new Filters(img).convolve(blurMask)));
  // Click listener for sobel.
  querySelector('[name = "sobel"]').onClick.listen(
      (e) => toggleFilter('sobel',
          () => new Filters(img).sobel(hSobelMask, vSobelMask)));
  // Click listener for custom.
  querySelector('[name = "custom"]').onClick.listen(
      (e) => toggleFilter('custom', () {
        var matrix = querySelector('#customMatrix').querySelectorAll('input');
        var mask = new List();
        for (var i = 0; i < matrix.length; i++) {
          mask.add(double.parse(matrix[i].value));
        }
        return new Filters(img).convolve(mask, true);
      }));
}

// Add copies of the original image to each canvas element.
void populateImages(ImageElement img) {
  var canvases = querySelectorAll('canvas');
  for(var i = 0; i < canvases.length; i++) {
    var canvas = canvases[i];
    canvas.parent.insertBefore(img.clone(true), canvas);
    canvas.classes.add('hide');
  }
}

// Put the filtered image back to its original (unfiltered) condition.
void restoreContent(String id) {
  var canvas = querySelector('#$id');
  canvas.classes.remove('show');
  canvas.classes.add('hide');
  canvas.previousElementSibling.classes.remove('hide');
  canvas.previousElementSibling.classes.add('show');
  canvas.parent.querySelector('button').text = 'apply $id filter';
}

// Show the filtered image.
void filterImage(String id, ImageData pixels) {
  CanvasElement canvas = querySelector('#$id');
  canvas.width = pixels.width;
  canvas.height = pixels.height;
  canvas.getContext('2d') as CanvasRenderingContext2D
      ..putImageData(pixels, 0, 0);
  canvas.previousElementSibling.classes.remove('show');
  canvas.previousElementSibling.classes.add('hide');
  canvas.classes.remove('hide');
  canvas.classes.add('show');
  canvas.parent.querySelector('button').text = 'remove $id filter';
}

// Handle applying the filter to the image.
typedef ImageData ApplyFilter();
void toggleFilter(String id, ApplyFilter filter) {
  if (querySelector('#$id').previousElementSibling.classes.contains('hide')) {
    restoreContent(id);
  } else {
    filterImage(id, filter());
  }
}
