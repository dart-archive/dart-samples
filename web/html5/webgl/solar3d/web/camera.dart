// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class Camera {
  Vector3 eyePosition;
  Vector3 upDirection;
  Vector3 lookAtPosition;
  double zNear;
  double zFar;
  double aspectRatio;
  double fOV;

  Camera() {
    eyePosition = new Vector3(0.0, 2.0, 0.0);
    lookAtPosition = new Vector3(1.0, 2.0, -1.0);
    upDirection = new Vector3(0.0, 1.0, 0.0);

    // Note: this was originally set to 0.785398163 (90 degrees).  Different
    // settings of fOV produce different visual results. Neither number is
    // incorrect.
    fOV = 0.35;
    zNear = 1.0;
    zFar = 1000.0;
    aspectRatio = 1.7777778;
  }

  String toString() {
    return '$eyePosition -> $lookAtPosition';
  }

  double get yaw {
    var z = new Vector3(0.0, 0.0, 1.0);
    var forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(z)));
  }

  double get pitch {
    var y = new Vector3(0.0, 1.0, 0.0);
    var forward = frontDirection;
    forward.normalize();
    return degrees(Math.acos(forward.dot(y)));
  }

  Matrix4 get projectionMatrix {
    return makePerspectiveMatrix(fOV, aspectRatio, zNear, zFar);
  }

  Matrix4 get lookAtMatrix {
    return makeViewMatrix(eyePosition, lookAtPosition, upDirection);
  }

  void copyProjectionMatrixIntoArray(Float32List pm) {
    var m = makePerspectiveMatrix(fOV, aspectRatio, zNear, zFar);
    m.copyIntoArray(pm);
  }

  void copyViewMatrixIntoArray(Float32List vm) {
    var m = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(vm);
  }

  void copyNormalMatrixIntoArray(Float32List nm) {
    var m = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
    m.copyIntoArray(nm);
  }

  void copyProjectionMatrix(Matrix4 pm) {
    var m = makePerspectiveMatrix(fOV, aspectRatio, zNear, zFar);
    m.copyInto(pm);
  }

  void copyViewMatrix(Matrix4 vm) {
    var m = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
    m.copyInto(vm);
  }

  void copyNormalMatrix(Matrix4 nm) {
    var m = makeViewMatrix(eyePosition, lookAtPosition, upDirection);
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
