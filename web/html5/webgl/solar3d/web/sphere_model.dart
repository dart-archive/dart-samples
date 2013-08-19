// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class SphereModel {
  static WebGL.Buffer indexBuffer;
  static WebGL.Buffer vertexBuffer;
  static int _vertexCount;
  static int _vertexStride;
  static int _positionAttributeIndex;
  static int _textureAttributeIndex;
  static int _normalAttributeIndex;

  static void setup(WebGL.RenderingContext gl) {
    assert(gl != null);

    // Create WebGL. Buffer to store index data.
    indexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    // Create Typed Array filled with index data.
    var indexList = _sphereData['meshes'][0]['indices'];
    var indexArray = new Uint16List.fromList(indexList);
    // Upload index array to WebGL. index buffer
    // Usage tagged as static because it will never change.
    gl.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER,
                  indexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    _vertexCount = indexList.length;
    _vertexStride = _sphereData['meshes'][0]['attributes']['POSITION']['stride'];
    // Create WebGL. Buffer to store vertex data.
    vertexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    // Created Typed Array filled with vertex data.
    var vertexList = _sphereData['meshes'][0]['vertices'];
    var vertexArray = new Float32List.fromList(vertexList);
    // Upload vertex array to WebGL. vertex buffer
    // Usage tagged as static because it will never change.
    gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                  vertexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
  }

  static void bindToProgram(WebGL.RenderingContext gl, WebGL.Program program) {
    _positionAttributeIndex = gl.getAttribLocation(program, 'vPosition');
    _textureAttributeIndex = gl.getAttribLocation(program, 'vTexCoord');
    _normalAttributeIndex = gl.getAttribLocation(program, 'vNormal');
  }

  static void prerender(WebGL.RenderingContext gl) {
    gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.enableVertexAttribArray(_positionAttributeIndex);
    gl.vertexAttribPointer(_positionAttributeIndex,
                           3, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, _vertexStride,
                           0); // 0 offset
    gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.enableVertexAttribArray(_normalAttributeIndex);
    gl.vertexAttribPointer(_normalAttributeIndex,
                           3, WebGL.RenderingContext.FLOAT,
                           false, _vertexStride,
                           12);
    gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.enableVertexAttribArray(_textureAttributeIndex);
    gl.vertexAttribPointer(_textureAttributeIndex,
                           2, WebGL.RenderingContext.FLOAT,
                           false, _vertexStride,
                           48);
  }

  static void render(WebGL.RenderingContext gl) {
    gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.drawElements(WebGL.RenderingContext.TRIANGLES, _vertexCount,
                    WebGL.RenderingContext.UNSIGNED_SHORT, 0);
  }
}
