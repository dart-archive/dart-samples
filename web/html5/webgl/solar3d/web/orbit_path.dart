// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class OrbitPath {
  final WebGL.RenderingContext _gl;
  WebGL.Buffer _vertexBuffer;
  Shader shader;
  int _vertexStride;
  int _vertexCount;
  WebGL.UniformLocation _radiusLocation;
  WebGL.UniformLocation _originLocation;
  WebGL.UniformLocation _colorLocation;
  WebGL.UniformLocation _cameraLocation;
  int _positionAttributeIndex;

  void _makeShader() {
    String _vertexShader = '''
      precision highp float;
      attribute vec3 vPosition;

      uniform vec4 origin;
      uniform float radius;

      uniform mat4 cameraTransform;
      void main() {
        vec4 vPosition4 = vec4(vPosition.x*radius,
                               vPosition.y*radius,
                               vPosition.z*radius, 1.0);
        vPosition4 += origin;
        gl_Position = cameraTransform*vPosition4;
      }
''';
    String _fragmentShader = '''
      precision highp float;
      uniform vec4 color;
      void main() {
        gl_FragColor = color;
      }
''';
    shader = new Shader(_vertexShader, _fragmentShader);
    shader.compile(_gl);
    shader.link(_gl);
    _cameraLocation = _gl.getUniformLocation(shader.program, 'cameraTransform');
    _originLocation = _gl.getUniformLocation(shader.program, 'origin');
    _radiusLocation = _gl.getUniformLocation(shader.program, 'radius');
    _colorLocation = _gl.getUniformLocation(shader.program, 'color');
    _positionAttributeIndex = _gl.getAttribLocation(shader.program, 'vPosition');
  }

  set cameraTransform(Matrix4 m) {
    var v = new Float32List(16);
    m.copyIntoArray(v);
    _gl.useProgram(shader.program);
    _gl.uniformMatrix4fv(_cameraLocation, false, v);
  }

  void _makePath() {
    final int segments = 64;

    var alpha = 0.0;
    var twoPi = (2.0 * 3.141592653589793238462643);
    var _step = twoPi/segments;
    var radius = 1.0;

    var center = new Vector3.zero();
    var _circle_u = new Vector3(1.0, 0.0, 0.0);
    var _circle_v = new Vector3(0.0, 0.0, 1.0);
    var last = center + _circle_u * radius;

    var vertexPositions = new List<double>();
    for (alpha = _step; alpha <= twoPi; alpha += _step) {
      var p = center + (_circle_u.scaled(radius * Math.cos(alpha)));
      p += (_circle_v.scaled(radius * Math.sin(alpha)));
      vertexPositions.add(p.x);
      vertexPositions.add(p.y);
      vertexPositions.add(p.z);
      vertexPositions.add(last.x);
      vertexPositions.add(last.y);
      vertexPositions.add(last.z);
      last = p;
    }
    var pl = center + _circle_u * radius;
    vertexPositions.add(pl.x);
    vertexPositions.add(pl.y);
    vertexPositions.add(pl.z);
    vertexPositions.add(last.x);
    vertexPositions.add(last.y);
    vertexPositions.add(last.z);
    var vertexData = new Float32List.fromList(vertexPositions);
    _vertexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, _vertexBuffer);
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                   vertexData,
                   WebGL.RenderingContext.STATIC_DRAW);
    _vertexCount = vertexPositions.length ~/ 3;
    _vertexStride = 12;
  }

  OrbitPath(this._gl) {
    _makePath();
    _makeShader();
  }

  void preRender() {
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, _vertexBuffer);
    _gl.enableVertexAttribArray(_positionAttributeIndex);
    _gl.vertexAttribPointer(_positionAttributeIndex,
                           3, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, _vertexStride,
                           0); // 0 offset
  }

  void render(double radius, Vector3 origin, Vector4 color) {
    _gl.useProgram(shader.program);
    _gl.uniform4f(_originLocation, origin.x, origin.y, origin.z, 0.0);
    _gl.uniform4f(_colorLocation, color.x, color.y, color.z, color.w);
    _gl.uniform1f(_radiusLocation, radius);
    _gl.drawArrays(WebGL.RenderingContext.LINES, 0, _vertexCount);
  }
}
