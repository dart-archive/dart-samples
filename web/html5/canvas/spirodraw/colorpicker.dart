// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of spirodraw;

typedef void PickerListener(String selectedColor);

class ColorPicker {
  static const hexValues = const ['00', '33', '66', '99', 'CC', 'FF'];
  static const COLS = 18;
  // Block height, width, padding
  static const BH = 10;
  static const BW = 10;
  static const BP = 1;
  final List<PickerListener> _listeners;
  CanvasElement canvasElement;
  String _selectedColor = 'red';
  final height = 160;
  final width = 180;
  CanvasRenderingContext2D ctx;

  ColorPicker(this.canvasElement) :
    _listeners = []
  {
    ctx = canvasElement.context2D;
    drawPalette();
    addHandlers();
    showSelected();
  }

  String get selectedColor => _selectedColor;

  void set selectedColor(String color) {
    _selectedColor = color;

    showSelected();
    fireSelected();
  }

  void onMouseMove(MouseEvent event) {
    int x = event.offset.x;
    int y = event.offset.y - 40;
    if (( y < 0) || (x >= width)) {
      return;
    }
    ctx.fillStyle = getHexString(getColorIndex(x, y));
    ctx.fillRect(0, 0, width/2, 30);
  }

  void onMouseDown(MouseEvent event) {
    Element elt = event.target;
    event.cancelBubble = true;
    int x = event.offset.x;
    int y = event.offset.y - 40;
    if ((y < 0) || (x >= width)) {
      return;
    }
    selectedColor = getHexString(getColorIndex(x, y));
  }

  /**
   * Adds a [PickerListener] to receive updates.
   */
  void addListener(PickerListener listener) {
    _listeners.add(listener);
  }

  void addHandlers() {
    canvasElement.onMouseMove.listen(onMouseMove);
    canvasElement.onMouseDown.listen(onMouseDown);
  }

  void drawPalette() {
    int i=0;
    for (int r=0; r < 256; r+=51) {
      for (int g=0; g < 256; g+=51) {
        for (int b=0; b < 256; b+=51) {
          String color = getHexString(i);
          ctx.fillStyle = color;
          int x = BW * (i % COLS);
          int y = BH * (i ~/ COLS) + 40;
          ctx.fillRect(x + BP, y + BP, BW - 2 * BP, BH - 2 * BP);
          i++;
        }
      }
    }
  }

  void fireSelected() {
    for (final listener in _listeners) {
      listener(_selectedColor);
    }
  }

  int getColorIndex(int x, int y) {
    // Get color index 0-215 using row, col
    int i = y ~/ BH * COLS + x ~/ BW;
    return i;
  }

  void showSelected() {
    ctx.fillStyle = _selectedColor;
    ctx.fillRect(width / 2, 0, width / 2, 30);
    ctx.fillStyle = "white";
    ctx.fillRect(0, 0, width / 2, 30);
  }

  String getHexString(num value) {
    int i = value.floor().toInt();

    int r = (i ~/ 36) % 6;
    int g = (i % 36) ~/ 6;
    int b = i % 6;

    return '#${hexValues[r]}${hexValues[g]}${hexValues[b]}';
  }

}
