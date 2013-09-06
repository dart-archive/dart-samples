// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library spirodraw;

import 'dart:html';
import 'dart:math' as Math;

part "colorpicker.dart";

void main() {
  new Spirodraw().go();
}

class Spirodraw {
  static double PI2 = Math.PI * 2;
  Document doc;
  // Scale factor used to scale wheel radius from 1-10 to pixels
  int RUnits, rUnits, dUnits;
  // Fixed radius, wheel radius, pen distance in pixels
  double R, r, d;
  InputElement fixedRadiusSlider, wheelRadiusSlider,
    penRadiusSlider, penWidthSlider, speedSlider;
  SelectElement inOrOut;
  DivElement mainDiv;
  num lastX, lastY;
  int height, width, xc, yc;
  int maxTurns;
  CanvasElement frontCanvas, backCanvas;
  CanvasRenderingContext2D front, back;
  CanvasElement paletteElement;
  ColorPicker colorPicker;
  String penColor = "red";
  int penWidth;
  double rad = 0.0;
  double stepSize;
  bool animationEnabled = true;
  int numPoints;
  double speed;
  bool run;

  Spirodraw() {
    doc = window.document;
    inOrOut = doc.query("#in_out");
    fixedRadiusSlider = doc.query("#fixed_radius");
    wheelRadiusSlider = doc.query("#wheel_radius");
    penRadiusSlider = doc.query("#pen_radius");
    penWidthSlider = doc.query("#pen_width");
    speedSlider = doc.query("#speed");
    mainDiv = doc.query("#main");
    frontCanvas = doc.query("#canvas");
    front = frontCanvas.context2D;
    backCanvas = new Element.tag("canvas");
    back = backCanvas.context2D;
    paletteElement = doc.query("#palette");
    window.onResize.listen(onResize);
    initControlPanel();
  }

  void go() {
    onResize(null);
  }

  void onResize(Event event) {
    height = window.innerHeight;
    width = window.innerWidth - 270;
    yc = height ~/ 2;
    xc = width ~/ 2;
    frontCanvas..height = height
               ..width = width;
    backCanvas..height = height
              ..width = width;
    clear();
  }

  void initControlPanel() {
    inOrOut.onChange.listen((_) => refresh());
    fixedRadiusSlider.onChange.listen((_) => refresh());
    wheelRadiusSlider.onChange.listen((_) => refresh());
    speedSlider.onChange.listen(onSpeedChange);
    penRadiusSlider.onChange.listen((_) => refresh());
    penWidthSlider.onChange.listen(onPenWidthChange);

    colorPicker = new ColorPicker(paletteElement);
    colorPicker.addListener((String color) => onColorChange(color));

    doc.query("#start").onClick.listen((_) => start());
    doc.query("#stop").onClick.listen((_) => stop());
    doc.query("#clear").onClick.listen((_) => clear());
    doc.query("#lucky").onClick.listen((_) => lucky());
  }

  void onColorChange(String color) {
    penColor = color;
    drawFrame(rad);
  }

  void onSpeedChange(Event event) {
    speed = speedSlider.valueAsNumber;
    stepSize = calcStepSize();
  }

  void onPenWidthChange(Event event) {
    penWidth = penWidthSlider.valueAsNumber.toInt();
    drawFrame(rad);
  }

  void refresh() {
    stop();
    // Reset
    lastX = lastY = 0;
    // Compute fixed radius
    // based on starting diameter == min / 2, fixed radius == 10 units
    int min = Math.min(height, width);
    double pixelsPerUnit = min / 40;
    RUnits = fixedRadiusSlider.valueAsNumber.toInt();
    R = RUnits * pixelsPerUnit;
    // Scale inner radius and pen distance in units of fixed radius
    rUnits = wheelRadiusSlider.valueAsNumber.toInt();
    r = rUnits * R/RUnits * int.parse(inOrOut.value);
    dUnits = penRadiusSlider.valueAsNumber.toInt();
    d = dUnits * R/RUnits;
    numPoints = calcNumPoints();
    maxTurns = calcTurns();
    onSpeedChange(null);
    penWidth = penWidthSlider.valueAsNumber.toInt();
    drawFrame(0.0);
  }

  int calcNumPoints() {
    // Empirically, treat it like an oval.
    if (dUnits == 0 || rUnits == 0) return 2;

    int gcf_ = gcf(RUnits, rUnits);
    int n = RUnits ~/ gcf_;
    int d_ = rUnits ~/ gcf_;
    if (n % 2 == 1) return n;
    if (d_% 2 == 1) return n;
    return n~/2;
  }

  double calcStepSize() => speed / 100 * maxTurns / numPoints;

  void drawFrame(double theta) {
    if (animationEnabled) {
      front..clearRect(0, 0, width, height)
           ..drawImage(backCanvas, 0, 0);
      drawFixed();
    }
    drawWheel(theta);
  }

  void animate(double time) {
    if (run && rad <= maxTurns * PI2) {
      rad+=stepSize;
      drawFrame(rad);
      window.requestAnimationFrame(animate);
    } else {
      stop();
    }
  }

  void start() {
    refresh();
    rad = 0.0;
    run = true;
    window.requestAnimationFrame(animate);
  }

  int calcTurns() {
    // compute ratio of wheel radius to big R then find LCM
    if ((dUnits==0) || (rUnits==0)) return 1;
    int ru = rUnits.abs();
    int wrUnits = RUnits + rUnits;
    int g = gcf (wrUnits, ru);
    return ru ~/ g;
  }

  void stop() {
    run = false;
    // Show drawing only
    front..clearRect(0, 0, width, height)
         ..drawImage(backCanvas, 0, 0);
    // Reset angle
    rad = 0.0;
  }

  void clear() {
    stop();
    back.clearRect(0, 0, width, height);
    refresh();
  }

  /**
   * Choose random settings for wheel and pen, but leave fixed radius alone as
   * it often changes things too much.
   */
  void lucky() {
    var rand = new Math.Random();
    wheelRadiusSlider.valueAsNumber = rand.nextDouble() * 9;
    penRadiusSlider.valueAsNumber = rand.nextDouble() * 9;
    penWidthSlider.valueAsNumber = 1 + rand.nextDouble() * 9;
    colorPicker.selectedColor = colorPicker.getHexString(rand.nextDouble() * 215);
    start();
  }

  void drawFixed() {
    if (animationEnabled) {
      front..beginPath()
           ..lineWidth = 2
           ..strokeStyle = "gray"
           ..arc(xc, yc, R, 0, PI2, true)
           ..closePath()
           ..stroke();
    }
  }

  /**
   * Draw the wheel with its center at angle theta with respect to the fixed
   * wheel
   */
  void drawWheel(double theta) {
    double wx = xc + ((R + r) * Math.cos(theta));
    double wy = yc - ((R + r) * Math.sin(theta));
    if (animationEnabled) {
      if (rUnits>0) {
        // Draw ring
        front..beginPath()
             ..arc(wx, wy, r.abs(), 0, PI2, true)
             ..closePath()
             ..stroke();
        // Draw center
        front..lineWidth = 1
             ..beginPath()
             ..arc(wx, wy, 3, 0, PI2, true)
             ..fillStyle = "black"
             ..fill()
             ..closePath()
             ..stroke();
      }
    }
    drawTip(wx, wy, theta);
  }

  /**
   * Draw a rotating line that shows the wheel rolling and leaves the pen trace
   *
   * [wx]    - X coordinate of wheel center
   * [wy]    - Y coordinate of wheel center
   * [theta] -  Angle of wheel center with respect to fixed circle
   */
  void drawTip(double wx, double wy, double theta) {
    // Calc wheel rotation angle
    double rot = (r==0) ? theta : theta * (R+r) / r;
    // Find tip of line
    double tx = wx + d * Math.cos(rot);
    double ty = wy - d * Math.sin(rot);
    if (animationEnabled) {
      front..beginPath()
           ..fillStyle = penColor
           ..arc(tx, ty, penWidth/2+2, 0, PI2, true)
           ..fill()
           ..moveTo(wx, wy)
           ..strokeStyle = "black"
           ..lineTo(tx, ty)
           ..closePath()
           ..stroke();
    }
    drawSegmentTo(tx, ty);
  }

  void drawSegmentTo(double tx, double ty) {
    if (lastX > 0) {
      back..beginPath()
          ..strokeStyle = penColor
          ..lineWidth = penWidth
          ..moveTo(lastX, lastY)
          ..lineTo(tx, ty)
          ..closePath()
          ..stroke();
    }
    lastX = tx;
    lastY = ty;
  }
}

int gcf(int n, int d) {
  if (n == d) return n;
  int max = Math.max(n, d);

  for (int i = max ~/ 2; i > 1; i--) {
    if ((n % i == 0) && (d % i == 0)) return i;
  }

  return 1;
}
