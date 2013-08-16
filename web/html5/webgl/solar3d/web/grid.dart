// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class Grid {
  final WebGLRenderingContext gl;
  WebGLBuffer vertexBuffer;
  WebGLShader vertexShader;
  WebGLShader fragmentShader;
  WebGLProgram shaderProgram;
  int numVertices;

  Grid(this.gl) {
    _generateVertexBuffer();

    vertexShader = gl.createShader(WebGLRenderingContext.VERTEX_SHADER);
    fragmentShader = gl.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
    shaderProgram = gl.createProgram();

    gl.shaderSource(vertexShader, '''
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

    gl.shaderSource(fragmentShader, '''
      precision mediump float;
      varying vec4 fColor;
      void main() {
        gl_FragColor = fColor;
      }
    ''');

    gl.compileShader(vertexShader);
    gl.compileShader(fragmentShader);
    gl.attachShader(shaderProgram, vertexShader);
    gl.attachShader(shaderProgram, fragmentShader);
    gl.linkProgram(shaderProgram);
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
                      vec3 e, vec3 step, vec4 color, int num) {
    vec3 lineStart = new vec3.copy(b);
    vec3 lineEnd = new vec3.copy(e);
    for (int i = 0; i < num; i++) {
      _generateLine(vertexBuffer, lineStart, lineEnd, color);
      lineStart.add(step);
      lineEnd.add(step);
    }
  }

  void _generateVertexBuffer() {
    vertexBuffer = gl.createBuffer();
    List<num> vertexBufferData = new List<num>();

    var colors = {
      'red': new vec4.raw(1.0, 0.0, 0.0, 1.0),
      'green': new vec4.raw(0.0, 1.0, 0.0, 1.0),
      'blue': new vec4.raw(0.0, 0.0, 1.0, 1.0)
    };

    // Bottom
    vec3 b = new vec3.raw(0.0, 0.0, -20.0);
    vec3 e = new vec3.raw(0.0, 0.0, 0.0);
    vec3 s = new vec3.raw(1.0, 0.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['green'], 21);
    b.setComponents(0.0, 0.0, 0.0);
    e.setComponents(20.0, 0.0, 0.0);
    s.setComponents(0.0, 0.0, -1.0);
    _generateLines(vertexBufferData, b, e, s, colors['green'], 21);

    // Side
    b.setComponents(20.0, 0.0, 0.0);
    e.setComponents(20.0, 20.0, 0.0);
    s.setComponents(0.0, 0.0, -1.0);
    _generateLines(vertexBufferData, b, e, s, colors['blue'], 21);
    b.setComponents(20.0, 0.0, 0.0);
    e.setComponents(20.0, 0.0, -20.0);
    s.setComponents(0.0, 1.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['blue'], 21);

    // Side
    b.setComponents(0.0, 0.0, -20.0);
    e.setComponents(0.0, 20.0, -20.0);
    s.setComponents(1.0, 0.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['red'], 21);
    b.setComponents(0.0, 0.0, -20.0);
    e.setComponents(20.0, 0.0, -20.0);
    s.setComponents(0.0, 1.0, 0.0);
    _generateLines(vertexBufferData, b, e, s, colors['red'], 21);

    numVertices = vertexBufferData.length~/7;
    gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER,
                     new Float32Array.fromList(vertexBufferData),
                     WebGLRenderingContext.STATIC_DRAW);
  }

  void draw(Float32Array camera) {
    gl.enableVertexAttribArray(0);
    gl.enableVertexAttribArray(1);
    gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.vertexAttribPointer(0, 4, WebGLRenderingContext.FLOAT, false, 28, 12);
    gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.vertexAttribPointer(1, 3, WebGLRenderingContext.FLOAT, false, 28, 0);

    gl.useProgram(shaderProgram);
    var cameraTransformUniformIndex = gl.getUniformLocation(shaderProgram,
                                                               'cameraTransform');

    gl.uniformMatrix4fv(cameraTransformUniformIndex,
                           false,
                           camera);
    gl.drawArrays(WebGLRenderingContext.LINES, 0, numVertices);
    gl.flush();
  }
}
