// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class SphereModel {
  static WebGLBuffer indexBuffer;
  static WebGLBuffer vertexBuffer;
  static int _vertexCount;
  static int _vertexStride;
  static int _positionAttributeIndex;
  static int _textureAttributeIndex;
  static int _normalAttributeIndex;

  static void setup(WebGLRenderingContext gl) {
    assert(gl != null);

    // Create WebGL Buffer to store index data.
    indexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    // Create Typed Array filled with index data.
    var indexList = _sphereData['meshes'][0]['indices'];
    var indexArray = new Uint16Array.fromList(indexList);
    // Upload index array to WebGL index buffer
    // Usage tagged as static because it will never change.
    gl.bufferData(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER,
                  indexArray,
                  WebGLRenderingContext.STATIC_DRAW);
    _vertexCount = indexList.length;
    _vertexStride = _sphereData['meshes'][0]['attributes']['POSITION']['stride'];
    // Create WebGL Buffer to store vertex data.
    vertexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    // Created Typed Array filled with vertex data.
    var vertexList = _sphereData['meshes'][0]['vertices'];
    var vertexArray = new Float32Array.fromList(vertexList);
    // Upload vertex array to WebGL vertex buffer
    // Usage tagged as static because it will never change.
    gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER,
                  vertexArray,
                  WebGLRenderingContext.STATIC_DRAW);
  }

  static void bindToProgram(WebGLRenderingContext gl, WebGLProgram program) {
    _positionAttributeIndex = gl.getAttribLocation(program, 'vPosition');
    _textureAttributeIndex = gl.getAttribLocation(program, 'vTexCoord');
    _normalAttributeIndex = gl.getAttribLocation(program, 'vNormal');
  }

  static void prerender(WebGLRenderingContext gl) {
    gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.enableVertexAttribArray(_positionAttributeIndex);
    gl.vertexAttribPointer(_positionAttributeIndex,
                           3, WebGLRenderingContext.FLOAT, // 3 floats
                           false, _vertexStride,
                           0); // 0 offset
    gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.enableVertexAttribArray(_normalAttributeIndex);
    gl.vertexAttribPointer(_normalAttributeIndex,
                           3, WebGLRenderingContext.FLOAT,
                           false, _vertexStride,
                           12);
    gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.enableVertexAttribArray(_textureAttributeIndex);
    gl.vertexAttribPointer(_textureAttributeIndex,
                           2, WebGLRenderingContext.FLOAT,
                           false, _vertexStride,
                           48);
  }

  static void render(WebGLRenderingContext gl) {
    gl.bindBuffer(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.drawElements(WebGLRenderingContext.TRIANGLES, _vertexCount,
                    WebGLRenderingContext.UNSIGNED_SHORT, 0);
  }
}
