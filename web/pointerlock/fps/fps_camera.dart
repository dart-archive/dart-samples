// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of fps;

class Camera {
  Vector3 eyePosition;
  Vector3 upDirection;
  Vector3 lookAtPosition;
  num zNear;
  num zFar;
  num aspectRatio;
  num fOV;

  Camera() {
    eyePosition = new Vector3(0.0, 2.0, 0.0);
    lookAtPosition = new Vector3(1.0, 2.0, -1.0);
    upDirection = new Vector3(0.0, 1.0, 0.0);

    fOV = 0.785398163; // 90 degrees
    zNear = 1.0;
    zFar = 1000.0;
    aspectRatio = 1.7777778;
  }

  String toString() {
    return '$eyePosition -> $lookAtPosition';
  }

  num get yaw {
    Vector3 z = new Vector3(0.0, 0.0, 1.0);
    Vector3 forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(z)));
  }

  num get pitch {
    Vector3 y = new Vector3(0.0, 1.0, 0.0);
    Vector3 forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(y)));
  }

  Matrix4 get projectionMatrix {
    return makePerspective(fOV, aspectRatio, zNear, zFar);
  }

  Matrix4 get lookAtMatrix {
    return makeLookAt(eyePosition, lookAtPosition, upDirection);
  }

  void copyProjectionMatrixIntoArray(Float32List pm) {
    Matrix4 m = makePerspective(fOV, aspectRatio, zNear, zFar);
    m.copyIntoArray(pm);
  }

  void copyViewMatrixIntoArray(Float32List vm) {
    Matrix4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(vm);
  }

  void copyNormalMatrixIntoArray(Float32List nm) {
    Matrix4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(nm);
  }

  void copyProjectionMatrix(Matrix4 pm) {
    Matrix4 m = makePerspective(fOV, aspectRatio, zNear, zFar);
    m.copyInto(pm);
  }

  void copyViewMatrix(Matrix4 vm) {
    Matrix4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyInto(vm);
  }

  void copyNormalMatrix(Matrix4 nm) {
    Matrix4 m = makeLookAt(eyePosition, lookAtPosition, upDirection);
    m.copyInto(nm);
  }

  void copyEyePosition(Vector3 ep) {
    eyePosition.copyInto(ep);
  }

  void copyLookAtPosition(Vector3 lap) {
    lookAtPosition.copyInto(lap);
  }

  Vector3 get frontDirection => lookAtPosition - eyePosition;
}
