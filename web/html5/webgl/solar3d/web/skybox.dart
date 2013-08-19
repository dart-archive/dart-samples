// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class Skybox {
  final WebGL.RenderingContext gl;
  WebGL.Buffer indexBuffer;
  WebGL.Buffer vertexBuffer;
  WebGL.Shader vertexShader;
  WebGL.Shader fragmentShader;
  WebGL.Program program;
  WebGL.UniformLocation _cameraTransformLocation;

  int _positionAttributeIndex;
  int _textureAttributeIndex;
  int _vertexCount;
  int _vertexStride;

  Float32List _cameraTransform;

  void _setupBuffers() {
    var vertexPositions = const [
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
      1.0,  1.0, -1.0,
      1.0, -1.0, -1.0,

      -1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
      1.0,  1.0,  1.0,
      1.0, -1.0,  1.0,

      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      1.0, -1.0,  1.0,
      1.0, -1.0, -1.0,

      -1.0,  1.0, -1.0,
      -1.0,  1.0,  1.0,
      1.0,  1.0,  1.0,
      1.0,  1.0, -1.0,

      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
      -1.0,  1.0, -1.0,

      1.0, -1.0, -1.0,
      1.0, -1.0,  1.0,
      1.0,  1.0,  1.0,
      1.0,  1.0, -1.0];

    var vertexTextureCoords = const [
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
      1.0,  1.0, -1.0,
      1.0, -1.0, -1.0,

      -1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
      1.0,  1.0,  1.0,
      1.0, -1.0,  1.0,

      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      1.0, -1.0,  1.0,
      1.0, -1.0, -1.0,

      -1.0,  1.0, -1.0,
      -1.0,  1.0,  1.0,
      1.0,  1.0,  1.0,
      1.0,  1.0, -1.0,

      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
      -1.0,  1.0, -1.0,

      1.0, -1.0, -1.0,
      1.0, -1.0,  1.0,
      1.0,  1.0,  1.0,
      1.0,  1.0, -1.0];

    var indices = const [
      0,  1,  2, 0,  2,  3,
      4,  5,  6, 4,  6,  7,
      8,  9, 10, 8, 10, 11,
      12, 13, 14, 12, 14, 15,
      16, 17, 18, 16, 18, 19,
      20, 21, 22, 20, 22, 23];

    assert(vertexPositions.length == vertexTextureCoords.length);
    var vertexData = new Float32List(vertexPositions.length*2);
    int writeCursor = 0;
    for (int i = 0; i < vertexPositions.length; i += 3) {
      vertexData[writeCursor++] = vertexPositions[i];
      vertexData[writeCursor++] = vertexPositions[i+1];
      vertexData[writeCursor++] = vertexPositions[i+2];
      vertexData[writeCursor++] = vertexTextureCoords[i];
      vertexData[writeCursor++] = vertexTextureCoords[i+1];
      vertexData[writeCursor++] = vertexTextureCoords[i+2];
    }

    vertexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                  vertexData,
                  WebGL.RenderingContext.STATIC_DRAW);
    indexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER,
                  new Uint16List.fromList(indices),
                  WebGL.RenderingContext.STATIC_DRAW);
    _vertexCount = indices.length;
    _vertexStride = 4*6; // 6 floats per vertex
  }

  void _setupProgram() {
    final String _vertexShader = '''
      attribute vec3 vPosition;
      attribute vec3 vTexCoord;
      uniform mat4 cameraTransform;

      varying vec3 samplePoint;

      void main(void)
      {
        vec4 vPosition4 = vec4(vPosition.x*512.0,
                               vPosition.y*512.0,
                               vPosition.z*512.0,
                               1.0);
        gl_Position = cameraTransform*vPosition4;
        samplePoint = vTexCoord;
      }
    ''';
    final String _fragmentShader = '''
      precision highp float;
      varying vec3 samplePoint;
      uniform samplerCube skyMap;

      void main(void)
      {
        vec4 color = textureCube(skyMap, samplePoint);
        //gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
        gl_FragColor = vec4(color.xyz, 1.0);
      }
    ''';
    vertexShader = gl.createShader(WebGL.RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vertexShader, _vertexShader);
    gl.compileShader(vertexShader);
    printLog(gl.getShaderInfoLog(vertexShader));
    fragmentShader = gl.createShader(WebGL.RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, _fragmentShader);
    gl.compileShader(fragmentShader);
    printLog(gl.getShaderInfoLog(fragmentShader));
    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    printLog(gl.getProgramInfoLog(program));
    _cameraTransformLocation = gl.getUniformLocation(program,'cameraTransform');
    _positionAttributeIndex = gl.getAttribLocation(program, 'vPosition');
    _textureAttributeIndex = gl.getAttribLocation(program, 'vTexCoord');
  }

  Skybox(this.gl) {
    _setupBuffers();
    _setupProgram();
    _cameraTransform = new Float32List(16);
  }

  void preRender() {
    gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.enableVertexAttribArray(_positionAttributeIndex);
    gl.vertexAttribPointer(_positionAttributeIndex,
                           3, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, _vertexStride,
                           0); // 0 offset
    gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.enableVertexAttribArray(_textureAttributeIndex);
    gl.vertexAttribPointer(_textureAttributeIndex,
                           3, WebGL.RenderingContext.FLOAT,
                           false, _vertexStride,
                           12);
  }

  void render(Camera camera) {
    var P = camera.projectionMatrix;
    var LA = makeViewMatrix(new Vector3.zero(),
                         camera.frontDirection,
                         new Vector3(0.0, 1.0, 0.0));
    P.multiply(LA);
    P.copyIntoArray(_cameraTransform, 0);
    gl.useProgram(program);
    gl.uniformMatrix4fv(_cameraTransformLocation, false, _cameraTransform);
    gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.drawElements(WebGL.RenderingContext.TRIANGLES, _vertexCount,
                    WebGL.RenderingContext.UNSIGNED_SHORT, 0);
  }
}
