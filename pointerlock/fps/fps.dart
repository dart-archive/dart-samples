
#import('dart:html');
#import('dart:math', prefix:'Math');
#import('external/DartVectorMath/vector_math_html.dart');
#source('fps_camera.dart');
#source('fps_controller.dart');

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
  FpsControllerView(this.elementId) {
    camera = new Camera();
    controller = new MouseKeyboardCameraController();
    canvas = query(elementId);
    ownMouse = false;
    cameraTransform = new Float32Array(16);
  }

  void generateVertexBuffer() {
    vertexBuffer = webGL.createBuffer();
    List<num> gridData = new List<num>();
    numVertices = 0;
    for (var i = 0; i <= 20; i++) {
      var x = i * 1.0;
      var y = 0.0;
      var z0 = 0.0;
      var z1 = -20.0;
      var r = 0.0;
      var g = 1.0;
      var b = 0.0;
      var a = 1.0;
      gridData.add(x);
      gridData.add(y);
      gridData.add(z0);

      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
      gridData.add(x);
      gridData.add(y);
      gridData.add(z1);

      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
    }

    for (var i = 0; i <= 20; i++) {
      var x0 = 0.0;
      var x1 = 20.0;
      var y = 0.0;
      var z = i * -1.0;
      var r = 0.0;
      var g = 1.0;
      var b = 0.0;
      var a = 1.0;
      gridData.add(x0);
      gridData.add(y);
      gridData.add(z);
      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
      gridData.add(x1);
      gridData.add(y);
      gridData.add(z);
      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
    }

    for (var i = 0; i <= 20; i++) {
      var x = 20.0;
      var y0 = 0.0;
      var y1 = 20.0;
      var z = i * -1.0;
      var r = 0.65;
      var g = 0.17;
      var b = 0.17;
      var a = 1.0;
      gridData.add(x);
      gridData.add(y0);
      gridData.add(z);

      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);

      numVertices++;
      gridData.add(x);
      gridData.add(y1);
      gridData.add(z);

      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
    }

    for (var i = 0; i <= 20; i++) {
      var x = 20.0;
      var y = i * 1.0;
      var z0 = 0.0;
      var z1 = -20.0;
      var r = 0.65;
      var g = 0.17;
      var b = 0.17;
      var a = 1.0;
      gridData.add(x);
      gridData.add(y);
      gridData.add(z0);
      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
      gridData.add(x);
      gridData.add(y);
      gridData.add(z1);
      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
    }

    for (var i = 0; i <= 20; i++) {
      var x = i * 1.0;
      var y0 = 0.0;
      var y1 = 20.0;
      var z = -20.0;
      var r = 0.65;
      var g = 0.6;
      var b = 0.3;
      var a = 1.0;
      gridData.add(x);
      gridData.add(y0);
      gridData.add(z);

      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);

      numVertices++;
      gridData.add(x);
      gridData.add(y1);
      gridData.add(z);

      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
    }

    for (var i = 0; i <= 20; i++) {
      var x0 = 0.0;
      var x1 = 20.0;
      var y = i * 1.0;
      var z = -20.0;
      var r = 0.65;
      var g = 0.6;
      var b = 0.3;
      var a = 1.0;
      gridData.add(x0);
      gridData.add(y);
      gridData.add(z);
      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
      gridData.add(x1);
      gridData.add(y);
      gridData.add(z);
      gridData.add(r);
      gridData.add(g);
      gridData.add(b);
      gridData.add(a);
      numVertices++;
    }

    webGL.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    webGL.bufferData(WebGLRenderingContext.ARRAY_BUFFER,
                    new Float32Array.fromList(gridData),
                    WebGLRenderingContext.STATIC_DRAW);
  }

  void setup() {
    if (canvas == null) {
      return;
    }
    canvas.width = 640;
    canvas.height = 480;
    webGL = canvas.getContext("experimental-webgl");
    if (webGL == null) {
      print('error');
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

    generateVertexBuffer();
  }

  void clicked(Event event) {
    if (canvas == null) {
      return;
    }
    canvas.webkitRequestPointerLock();
  }

  void pointerLockChange(Event event) {
    if (canvas == null) {
      return;
    }
    ownMouse = canvas == document.webkitPointerLockElement;
  }

  void keydown(KeyboardEvent  event) {
    if (!ownMouse) {
      return;
    }
    switch (event.keyCode) {
      case 87:
        controller.forward = true;
        break;
      case 65:
        controller.strafeLeft = true;
        break;
      case 68:
        controller.strafeRight = true;
        break;
      case 83:
        controller.backward = true;
        break;
    }
  }

  void keyup(KeyboardEvent event) {
    if (!ownMouse) {
      return;
    }
    switch (event.keyCode) {
      case 87:
        controller.forward = false;
        break;
      case 65:
        controller.strafeLeft = false;
        break;
      case 68:
        controller.strafeRight = false;
        break;
      case 83:
        controller.backward = false;
        break;
    }
  }

  void mouseMove(MouseEvent event) {
    if (!ownMouse) {
      return;
    }
    controller.accumDX += event.webkitMovementX;
    controller.accumDY += event.webkitMovementY;
  }

  void install() {
    if (canvas == null) {
      return;
    }
    document.on.pointerLockChange.add(pointerLockChange);
    canvas.on.click.add(clicked);
    document.on.keyDown.add(keydown);
    document.on.keyUp.add(keyup);
    document.on.mouseMove.add(mouseMove);
  }

  void remove() {
    if (canvas == null) {
      return;
    }
    document.on.mouseMove.remove(mouseMove);
    document.on.keyDown.remove(keydown);
    document.on.keyUp.remove(keyup);
    canvas.on.click.remove(clicked);
    document.on.pointerLockChange.remove(pointerLockChange);
    ownMouse = false;
  }


  void update(int time) {
    if (lastTime == null) {
      lastTime = time;
      return;
    }
    num dt = (time - lastTime)/1000.0;
    lastTime = time;
    controller.UpdateCamera(dt, camera);
  }

  void draw() {
    webGL.viewport(0, 0, 640, 480);
    webGL.clearColor(0.0, 0.0, 0.0, 1.0);
    webGL.clearDepth(1.0);
    webGL.clear(WebGLRenderingContext.COLOR_BUFFER_BIT|
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

    {
      mat4 view = camera.lookAtMatrix;
      mat4 projection = camera.projectionMatrix;
      mat4 projectionView = projection * view;
      projectionView.copyIntoArray(cameraTransform, 0);
    }
    webGL.uniformMatrix4fv(cameraTransformUniformIndex,
                            false,
                            cameraTransform);
    webGL.drawArrays(WebGLRenderingContext.LINES, 0, numVertices);
    webGL.flush();
  }
}

FpsControllerView view;

bool animate(int time) {
  if (view != null) {
    view.update(time);
    view.draw();
  }
  window.requestAnimationFrame(animate);
}

void main() {
  view = new FpsControllerView('#webGLCanvas');
  view.setup();
  view.install();
  window.requestAnimationFrame(animate);
}
