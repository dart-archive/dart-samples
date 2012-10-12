/*
  Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
  for details. All rights reserved. Use of this source code is governed by a
  BSD-style license that can be found in the LICENSE file.
*/

/*
 * This is a port of: http://www.html5rocks.com/en/tutorials/pointerlock/intro/
 */

#import('dart:html');
#import('dart:math', prefix:'Math');
#import('package:dartvectormath/vector_math_html.dart');
#source('fps_camera.dart');
#source('fps_controller.dart');

FpsControllerView view;

class FpsControllerView {
  final String elementId;
  CanvasElement canvas;
  Camera camera;
  MouseKeyboardCameraController controller;
  bool ownMouse;
  WebGLRenderingContext webGL;
  WebGLShader vertexShader;
  WebGLShader fragmentShader;
  WebGLProgram shaderProgram;
  WebGLBuffer vertexBuffer;
  Float32Array cameraTransform;
  int numVertices;
  int lastTime;

  /*
   * [elementId] The dom ID of the canvas element the view should render into
   */
  FpsControllerView(this.elementId) {
    camera = new Camera();
    controller = new MouseKeyboardCameraController();
    canvas = query(elementId);
    ownMouse = false;
    cameraTransform = new Float32Array(16);
  }

  void _generateLine(List<num> vertexBuffer, vec3 b, vec3 e, vec4 color) {
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

  void _generateLines(List<num> vertexBuffer, vec3 b,
                      vec3 e, vec3 step, color, int num) {
    vec3 lineStart = new vec3.copy(b);
    vec3 lineEnd = new vec3.copy(e);
    for (int i = 0; i < num; i++) {
      _generateLine(vertexBuffer, lineStart, lineEnd, color);
      lineStart.add(step);
      lineEnd.add(step);
    }
  }

  void _generateVertexBuffer() {
    vertexBuffer = webGL.createBuffer();
    List<num> vertexBufferData = new List<num>();

    var colors = {
      'red': new vec4.raw(1.0, 0.0, 0.0, 1.0),
      'green': new vec4.raw(0.0, 1.0, 0.0, 1.0),
      'blue': new vec4.raw(0.0, 0.0, 1.0, 1.0)
    };

    /* Bottom */
    vec3 b = new vec3.raw(0.0, 0.0, -20.0);
    vec3 e = new vec3.raw(0.0, 0.0, 0.0);
    vec3 s = new vec3.raw(1.0, 0.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['green'], 21);
    b.setComponents(0.0, 0.0, 0.0);
    e.setComponents(20.0, 0.0, 0.0);
    s.setComponents(0.0, 0.0, -1.0);
    _generateLines(vertexBufferData, b, e, s, colors['green'], 21);

    /* Side */
    b.setComponents(20.0, 0.0, 0.0);
    e.setComponents(20.0, 20.0, 0.0);
    s.setComponents(0.0, 0.0, -1.0);
    _generateLines(vertexBufferData, b, e, s, colors['blue'], 21);
    b.setComponents(20.0, 0.0, 0.0);
    e.setComponents(20.0, 0.0, -20.0);
    s.setComponents(0.0, 1.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['blue'], 21);

    /* Side */
    b.setComponents(0.0, 0.0, -20.0);
    e.setComponents(0.0, 20.0, -20.0);
    s.setComponents(1.0, 0.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['red'], 21);
    b.setComponents(0.0, 0.0, -20.0);
    e.setComponents(20.0, 0.0, -20.0);
    s.setComponents(0.0, 1.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['red'], 21);

    numVertices = vertexBufferData.length~/7;
    webGL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    webGL.bufferData(WebGLRenderingContext.ARRAY_BUFFER,
                     new Float32Array.fromList(vertexBufferData),
                     WebGLRenderingContext.STATIC_DRAW);
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
    vertexShader = webGL.createShader(WebGLRenderingContext.VERTEX_SHADER);
    fragmentShader = webGL.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
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
    canvas.webkitRequestPointerLock();
  }

  /* Returns true if the pointer is owned by our canvas element */
  bool get _pointerLocked() => canvas == document.webkitPointerLockElement;

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
    controller.accumDX += event.webkitMovementX;
    controller.accumDY += event.webkitMovementY;
  }

  /* Subscribe to input events */
  void bind() {
    document.on.pointerLockChange.add(pointerLockChange);
    canvas.on.click.add(clicked);
    document.on.keyDown.add(keydown);
    document.on.keyUp.add(keyup);
    document.on.mouseMove.add(mouseMove);
  }

  /* Unsubscribe from input events */
  void unbind() {
    document.on.mouseMove.remove(mouseMove);
    document.on.keyDown.remove(keydown);
    document.on.keyUp.remove(keyup);
    canvas.on.click.remove(clicked);
    document.on.pointerLockChange.remove(pointerLockChange);
    ownMouse = false;
  }

  void update(int time) {
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
    webGL.clear(WebGLRenderingContext.COLOR_BUFFER_BIT |
                WebGLRenderingContext.DEPTH_BUFFER_BIT);
    webGL.disable(WebGLRenderingContext.DEPTH_TEST);

    webGL.enableVertexAttribArray(0);
    webGL.enableVertexAttribArray(1);
    webGL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    webGL.vertexAttribPointer(0, 4, WebGLRenderingContext.FLOAT, false, 28, 12);
    webGL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    webGL.vertexAttribPointer(1, 3, WebGLRenderingContext.FLOAT, false, 28, 0);

    webGL.useProgram(shaderProgram);
    var cameraTransformUniformIndex = webGL.getUniformLocation(shaderProgram,
                                                              'cameraTransform');

    mat4 view = camera.lookAtMatrix;
    mat4 projection = camera.projectionMatrix;
    mat4 projectionView = projection * view;
    projectionView.copyIntoArray(cameraTransform, 0);
    webGL.uniformMatrix4fv(cameraTransformUniformIndex,
                           false,
                           cameraTransform);
    webGL.drawArrays(WebGLRenderingContext.LINES, 0, numVertices);
    webGL.flush();
  }
}

bool animate(int time) {
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
