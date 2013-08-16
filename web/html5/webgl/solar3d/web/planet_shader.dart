// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class PlanetShader {
  Shader shader;
  WebGLProgram get program => shader.program;
  WebGLRenderingContext gl;
  WebGLUniformLocation cameraTransformLocation;
  WebGLUniformLocation objectTransformLocation;
  WebGLUniformLocation viewTransformLocation;
  WebGLUniformLocation objectScaleLocation;
  WebGLUniformLocation planetIndexLocation;
  Float32Array _cameraTransform;
  Float32Array _objectTransform;
  Float32Array _viewTransform;
  Float32Array _objectScale;

  PlanetShader(this.gl) {
    shader = new Shader(_planetVertexShader, _planetFragmentShader);
    _cameraTransform = new Float32Array(16);
    _objectTransform = new Float32Array(16);
    _viewTransform = new Float32Array(16);
    _objectScale = new Float32Array(4);
  }

  void prepare() {
    shader.compile(gl);
    shader.link(gl);
    cameraTransformLocation = gl.getUniformLocation(program, 'cameraTransform');
    objectTransformLocation = gl.getUniformLocation(program, 'objectTransform');
    objectScaleLocation = gl.getUniformLocation(program, 'objectScale');
    viewTransformLocation = gl.getUniformLocation(program, 'viewTransform');
    planetIndexLocation = gl.getUniformLocation(program, 'planetIndex');
    gl.useProgram(program);
    gl.uniform1i(gl.getUniformLocation(program, 'diffuse'), 0);
    gl.uniform1i(gl.getUniformLocation(program, 'clouds'), 1);
  }

  void enable() {
    gl.useProgram(program);
  }

  set cameraTransform(mat4 m) {
    m.copyIntoArray(_cameraTransform);
    gl.uniformMatrix4fv(cameraTransformLocation, false, _cameraTransform);
  }

  set objectTransform(mat4 m) {
    m.copyIntoArray(_objectTransform);
    gl.uniformMatrix4fv(objectTransformLocation, false, _objectTransform);
  }

  set objectScale(num m) {
    _objectScale[0] = m;
    _objectScale[1] = m;
    _objectScale[2] = m;
    _objectScale[3] = 1.0;
    gl.uniform4fv(objectScaleLocation, _objectScale);
  }

  set viewTransform(mat4 m) {
    m.copyIntoArray(_viewTransform);
    gl.uniformMatrix4fv(viewTransformLocation, false, _viewTransform);
  }

  set planetIndex(int i) {
    gl.uniform1i(planetIndexLocation, i);
  }
}

final String _planetVertexShader = '''
precision highp float;

attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

uniform mat4 objectTransform;
uniform vec4 objectScale;
uniform mat4 cameraTransform;
uniform mat4 viewTransform;

varying vec2 samplePoint;
varying vec3 normal;
varying vec3 lightDir;
varying float lightDistance;

void main() {
  // modelView goes from model space to view space.
  mat4 modelView = viewTransform*objectTransform;
  // Transform light position into view space.
  vec4 lightPosition = viewTransform * vec4(0.0, 0.0, 0.0, 1.0);
  vec4 vPosition4 = vec4(vPosition.x*objectScale.x,
                         vPosition.y*objectScale.y,
                         vPosition.z*objectScale.z, 1.0);
  // Vertex position in view space.
  vec4 ecPos = modelView*vPosition4;
  // Vector from light position to vertex position (both in view space).
  vec3 aux = vec3(lightPosition-ecPos);
  lightDistance = length(aux);
  lightDir = normalize(aux);
  // Translate normal by object's transformation.
  vec4 vNormal4 = vec4(vNormal.x, vNormal.y, vNormal.z, 0.0);
  normal = (modelView*vNormal4).xyz;
  samplePoint = vTexCoord;
  gl_Position = cameraTransform*objectTransform*vPosition4;
}
''';

final String _planetFragmentShader = '''
precision mediump float;

varying vec2 samplePoint;
varying vec3 normal;
varying vec3 lightDir;

uniform sampler2D diffuse;
uniform sampler2D clouds;
uniform int planetIndex;

void main() {
  vec4 mix = texture2D(diffuse, samplePoint);
  vec3 n = normalize(normal);
  vec3 ldn = normalize(lightDir);
  float NdotL = max(dot(n, ldn), 0.0);
  if (NdotL > 0.0) {
    mix += NdotL * vec4(1.0, 0.5, 0.0, 0.0);
  }
  gl_FragColor = mix;
}
''';