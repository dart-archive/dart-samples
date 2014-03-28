// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Pointer Lock And First Person Shooter Controls" to Dart.
// See: http://www.html5rocks.com/en/tutorials/pointerlock/intro/

library fps;
import 'dart:html';
import 'dart:web_gl';
import 'dart:typed_data';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart';
part 'fps_camera.dart';
part 'fps_controller.dart';
part 'quat.dart';
part 'opengl.dart';

FpsControllerView view;

class FpsControllerView {
  final String elementId;
  CanvasElement canvas;
  Camera camera;
  MouseKeyboardCameraController controller;
  bool ownMouse;
  RenderingContext webGL;
  Shader vertexShader;
  Shader fragmentShader;
  Program shaderProgram;
  Buffer vertexBuffer;
  Float32List cameraTransform;
  int numVertices;
  double lastTime;

  /**
   * [elementId] The dom ID of the canvas element the view should render into
   */
  FpsControllerView(this.elementId) {
    camera = new Camera();
    controller = new MouseKeyboardCameraController();
    canvas = querySelector(elementId);
    ownMouse = false;
    cameraTransform = new Float32List(16);
  }

  void _generateLine(List<double> vertexBuffer, Vector3 b, Vector3 e, Vector4 color) {
    vertexBuffer.add(b.x);
    vertexBuffer.add(b.y);
    vertexBuffer.add(b.z);
    vertexBuffer.add(color.r);
    vertexBuffer.add(color.g);
    vertexBuffer.add(color.b);
    vertexBuffer.add(color.a);
    vertexBuffer.add(e.x);
    vertexBuffer.add(e.y);
    vertexBuffer.add(e.z);
    vertexBuffer.add(color.r);
    vertexBuffer.add(color.g);
    vertexBuffer.add(color.b);
    vertexBuffer.add(color.a);
  }

  void _generateLines(List<double> vertexBuffer, Vector3 b,
                      Vector3 e, Vector3 step, Vector4 color, int num) {
    Vector3 lineStart = new Vector3.copy(b);
    Vector3 lineEnd = new Vector3.copy(e);
    for (int i = 0; i < num; i++) {
      _generateLine(vertexBuffer, lineStart, lineEnd, color);
      lineStart.add(step);
      lineEnd.add(step);
    }
  }

  void _generateVertexBuffer() {
    vertexBuffer = webGL.createBuffer();
    List<double> vertexBufferData = new List<double>();

    var colors = {
      'red': new Vector4(1.0, 0.0, 0.0, 1.0),
      'green': new Vector4(0.0, 1.0, 0.0, 1.0),
      'blue': new Vector4(0.0, 0.0, 1.0, 1.0)
    };

    // Bottom
    Vector3 b = new Vector3(0.0, 0.0, -20.0);
    Vector3 e = new Vector3(0.0, 0.0, 0.0);
    Vector3 s = new Vector3(1.0, 0.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['green'], 21);
    b.setValues(0.0, 0.0, 0.0);
    e.setValues(20.0, 0.0, 0.0);
    s.setValues(0.0, 0.0, -1.0);
    _generateLines(vertexBufferData, b, e, s, colors['green'], 21);

    // Side
    b.setValues(20.0, 0.0, 0.0);
    e.setValues(20.0, 20.0, 0.0);
    s.setValues(0.0, 0.0, -1.0);
    _generateLines(vertexBufferData, b, e, s, colors['blue'], 21);
    b.setValues(20.0, 0.0, 0.0);
    e.setValues(20.0, 0.0, -20.0);
    s.setValues(0.0, 1.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['blue'], 21);

    // Side
    b.setValues(0.0, 0.0, -20.0);
    e.setValues(0.0, 20.0, -20.0);
    s.setValues(1.0, 0.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['red'], 21);
    b.setValues(0.0, 0.0, -20.0);
    e.setValues(20.0, 0.0, -20.0);
    s.setValues(0.0, 1.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['red'], 21);

    numVertices = vertexBufferData.length~/7;
    webGL.bindBuffer(RenderingContext.ARRAY_BUFFER, vertexBuffer);
    webGL.bufferDataTyped(RenderingContext.ARRAY_BUFFER,
                     new Float32List.fromList(vertexBufferData),
                     RenderingContext.STATIC_DRAW);
  }

  void initWebGL() {
    if (canvas == null) {
      throw new Exception('canvas not found $elementId can\'t be found');
    }
    canvas.width = 640;
    canvas.height = 480;
    webGL = canvas.getContext("experimental-webgl");
    if (webGL == null) {
      throw new Exception('WebGL is not supported');
    }
    vertexShader = webGL.createShader(RenderingContext.VERTEX_SHADER);
    fragmentShader = webGL.createShader(RenderingContext.FRAGMENT_SHADER);
    shaderProgram = webGL.createProgram();

    webGL.shaderSource(vertexShader, '''
      precision highp float;
      attribute vec3 vPosition;
      attribute vec4 vColor;
      uniform mat4 cameraTransform;
      varying vec4 fColor;
      void main() {
        fColor = vColor;
        vec4 vPosition4 = vec4(vPosition.x, vPosition.y, vPosition.z, 1.0);
        gl_Position = cameraTransform*vPosition4;
      }
    ''');

    webGL.shaderSource(fragmentShader, '''
      precision mediump float;
      varying vec4 fColor;
      void main() {
        gl_FragColor = fColor;
      }
    ''');

    webGL.compileShader(vertexShader);
    webGL.compileShader(fragmentShader);
    webGL.attachShader(shaderProgram, vertexShader);
    webGL.attachShader(shaderProgram, fragmentShader);
    webGL.linkProgram(shaderProgram);

    _generateVertexBuffer();
  }

  void clicked(Event event) {
    canvas.requestPointerLock();
  }

  /* Returns true if the pointer is owned by our canvas element */
  bool get _pointerLocked => canvas == document.pointerLockElement;

  void pointerLockChange(Event event) {
    // Check if we own the mouse.
    ownMouse = _pointerLocked;
  }

  static const keyCodeA = 65;
  static const keyCodeD = 68;
  static const keyCodeS = 83;
  static const keyCodeW = 87;

  void keydown(KeyboardEvent  event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }

    switch (event.keyCode) {
      case keyCodeW:
        controller.forward = true;
        break;
      case keyCodeA:
        controller.strafeLeft = true;
        break;
      case keyCodeD:
        controller.strafeRight = true;
        break;
      case keyCodeS:
        controller.backward = true;
        break;
    }
  }

  void keyup(KeyboardEvent event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }
    switch (event.keyCode) {
      case keyCodeW:
        controller.forward = false;
        break;
      case keyCodeA:
        controller.strafeLeft = false;
        break;
      case keyCodeD:
        controller.strafeRight = false;
        break;
      case keyCodeS:
        controller.backward = false;
        break;
    }
  }

  void mouseMove(MouseEvent event) {
    if (!ownMouse) {
      // We don't rotate the view if we don't own the mouse
      return;
    }
    controller.accumDX += event.movement.x;
    controller.accumDY += event.movement.y;
  }

  // Subscribe to input events
  void bind() {
    document.onPointerLockChange.listen(pointerLockChange);
    canvas.onClick.listen(clicked);
    document.onKeyDown.listen(keydown);
    document.onKeyUp.listen(keyup);
    document.onMouseMove.listen(mouseMove);
  }

  void update(double time) {
    if (lastTime == null) {
      // This skips the first frame but gives us an origin in time.
      lastTime = time;
      return;
    }
    var dt = (time - lastTime) / 1000.0;
    lastTime = time;
    controller.updateCamera(dt, camera);
  }

  void draw() {
    webGL.viewport(0, 0, canvas.width, canvas.height);
    webGL.clearColor(0.0, 0.0, 0.0, 1.0);
    webGL.clearDepth(1.0);
    webGL.clear(RenderingContext.COLOR_BUFFER_BIT |
                RenderingContext.DEPTH_BUFFER_BIT);
    webGL.disable(RenderingContext.DEPTH_TEST);

    webGL.enableVertexAttribArray(0);
    webGL.enableVertexAttribArray(1);
    webGL.bindBuffer(RenderingContext.ARRAY_BUFFER, vertexBuffer);
    webGL.vertexAttribPointer(0, 4, RenderingContext.FLOAT, false, 28, 12);
    webGL.bindBuffer(RenderingContext.ARRAY_BUFFER, vertexBuffer);
    webGL.vertexAttribPointer(1, 3, RenderingContext.FLOAT, false, 28, 0);

    webGL.useProgram(shaderProgram);
    var cameraTransformUniformIndex = webGL.getUniformLocation(shaderProgram,
                                                               'cameraTransform');

    Matrix4 view = camera.lookAtMatrix;
    Matrix4 projection = camera.projectionMatrix;
    Matrix4 projectionView = projection * view;
    projectionView.copyIntoArray(cameraTransform, 0);
    webGL.uniformMatrix4fv(cameraTransformUniformIndex,
                           false,
                           cameraTransform);
    webGL.drawArrays(RenderingContext.LINES, 0, numVertices);
    webGL.flush();
  }
}

void animate(double time) {
  view.update(time);
  view.draw();
  window.requestAnimationFrame(animate);
}

void main() {
  view = new FpsControllerView('#webGLCanvas');
  view.initWebGL();
  view.bind();
  window.requestAnimationFrame(animate);
}
