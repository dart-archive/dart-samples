// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class Camera {
  vec3 eyePosition;
  vec3 upDirection;
  vec3 lookAtPosition;
  num zNear;
  num zFar;
  num aspectRatio;
  num fOV;

  Camera() {
    eyePosition = new vec3.raw(0.0, 2.0, 0.0);
    lookAtPosition = new vec3.raw(1.0, 2.0, -1.0);
    upDirection = new vec3.raw(0.0, 1.0, 0.0);

    //fOV = 0.785398163; // 90 degrees
    fOV = 0.35;
    zNear = 1.0;
    zFar = 1000.0;
    aspectRatio = 1.7777778;
  }

  String toString() {
    return '$eyePosition -> $lookAtPosition';
  }

  num get yaw {
    vec3 z = new vec3(0.0, 0.0, 1.0);
    vec3 forward = frontDirection;
    forward.normalize();
    return degrees(acos(forward.dot(z)));
  }

  num get pitch {
    vec3 y = new vec3(0.0, 1.0, 0.0);
    vec3 forward = frontDirection;
    forward.normalize();
    return degrees(acos(forward.dot(y)));
  }

  mat4 get projectionMatrix {
    return makePerspective(fOV, aspectRatio, zNear, zFar);
  }

  mat4 get lookAtMatrix {
    return makeLookAt(eyePosition, lookAtPosition, upDirection);
  }

  void copyProjectionMatrixIntoArray(Float32Array pm) {
    mat4 m = makePerspective(fOV, aspectRatio, zNear, zFar);
    m.copyIntoArray(pm);
  }

  void copyViewMatrixIntoArray(Float32Array vm) {
    mat4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(vm);
  }

  void copyNormalMatrixIntoArray(Float32Array nm) {
    mat4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(nm);
  }

  void copyProjectionMatrix(mat4 pm) {
    mat4 m = makePerspective(fOV, aspectRatio, zNear, zFar);
    m.copyInto(pm);
  }

  void copyViewMatrix(mat4 vm) {
    mat4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyInto(vm);
  }

  void copyNormalMatrix(mat4 nm) {
    mat4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyInto(nm);
  }

  void copyEyePosition(vec3 ep) {
    eyePosition.copyInto(ep);
  }

  void copyLookAtPosition(vec3 lap) {
    lookAtPosition.copyInto(lap);
  }

  vec3 get frontDirection => lookAtPosition - eyePosition;
}
