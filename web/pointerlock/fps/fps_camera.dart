// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of fps;

class Camera {
  vec3 eyePosition;
  vec3 upDirection;
  vec3 lookAtPosition;
  num zNear;
  num zFar;
  num aspectRatio;
  num fOV;

  Camera() {
    eyePosition = new vec3(0.0, 2.0, 0.0);
    lookAtPosition = new vec3(1.0, 2.0, -1.0);
    upDirection = new vec3(0.0, 1.0, 0.0);

    fOV = 0.785398163; // 90 degrees
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
    return makePerspectiveMatrix(fOV, aspectRatio, zNear, zFar);
  }

  mat4 get lookAtMatrix {
    return makeLookAt(eyePosition, lookAtPosition, upDirection);
  }

  void copyProjectionMatrixIntoArray(Float32List pm) {
    mat4 m = makePerspectiveMatrix(fOV, aspectRatio, zNear, zFar);
    m.copyIntoArray(pm);
  }

  void copyViewMatrixIntoArray(Float32List vm) {
    mat4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(vm);
  }

  void copyNormalMatrixIntoArray(Float32List nm) {
    mat4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(nm);
  }

  void copyProjectionMatrix(mat4 pm) {
    mat4 m = makePerspectiveMatrix(fOV, aspectRatio, zNear, zFar);
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

/** Returns an OpenGL LookAt matrix */
mat4 makeLookAt(vec3 eyePosition, vec3 lookAtPosition, vec3 upDirection) {
  vec3 z = lookAtPosition - eyePosition;
  z.normalize();
  vec3 x = z.cross(upDirection);
  x.normalize();
  vec3 y = x.cross(z);
  y.normalize();
  mat4 r = new mat4.zero();
  r.row0.xyz = x;
  r.row1.xyz = y;
  r.row2.xyz = -z;
  r.row3.w = 1.0;
  r = r.transposed();
  vec3 rotatedEye = r * -eyePosition;
  r.row3.xyz = rotatedEye;
  return r;
}
