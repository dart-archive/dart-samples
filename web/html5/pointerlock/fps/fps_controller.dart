// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


part of fps;

class MouseKeyboardCameraController {
  bool up = false;
  bool down = false;
  bool strafeLeft = false;
  bool strafeRight = false;
  bool forward = false;
  bool backward = false;

  num floatVelocity = 5.0;
  num strafeVelocity = 5.0;
  num forwardVelocity = 5.0;
  num mouseSensitivity = 360.0;

  int accumDX = 0;
  int accumDY = 0;

  MouseKeyboardCameraController();

  void updateCamera(num seconds, Camera cam) {
    _moveFloat(seconds, up, down, cam);
    _moveStrafe(seconds, strafeRight, strafeLeft, cam);
    _moveForward(seconds, forward, backward, cam);
    _rotateView(seconds, cam);
  }

  num _velocityScale(bool positive, bool negative) {
    num scale = 0.0;
    if (positive) {
      scale += 1.0;
    }
    if (negative) {
      scale -= 1.0;
    }
    return scale;
  }

  void _moveFloat(num dt, bool positive, bool negative, Camera cam) {
    var scale = _velocityScale(positive, negative);
    if (scale == 0.0) {
      return;
    }
    scale = scale * dt * floatVelocity;
    Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
    upDirection.scale(scale);
    cam.lookAtPosition.add(upDirection);
    cam.eyePosition.add(upDirection);
  }

  void _moveStrafe(num dt, bool positive, bool negative, Camera cam) {
    var scale = _velocityScale(positive, negative);
    if (scale == 0.0) {
      return;
    }
    scale = scale * dt * strafeVelocity;
    Vector3 frontDirection = cam.frontDirection;
    frontDirection.normalize();
    Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
    Vector3 strafeDirection = frontDirection.cross(upDirection);
    strafeDirection.scale(scale);
    cam.lookAtPosition.add(strafeDirection);
    cam.eyePosition.add(strafeDirection);
  }

  void _moveForward(num dt, bool positive, bool negative, Camera cam) {
    var scale = _velocityScale(positive, negative);
    if (scale == 0.0) {
      return;
    }
    scale = scale * dt * forwardVelocity;

    Vector3 frontDirection = cam.frontDirection;
    frontDirection.normalize();
    frontDirection.scale(scale);
    cam.lookAtPosition.add(frontDirection);
    cam.eyePosition.add(frontDirection);
  }

  void _rotateView(num dt, Camera cam) {
    Vector3 frontDirection = cam.frontDirection;
    frontDirection.normalize();
    Vector3 upDirection = new Vector3(0.0, 1.0, 0.0);
    Vector3 strafeDirection = frontDirection.cross(upDirection);
    strafeDirection.normalize();

    num mouseYawDelta = accumDX / mouseSensitivity;
    num mousePitchDelta = accumDY / mouseSensitivity;
    accumDX = 0;
    accumDY = 0;

    // Pitch rotation
    bool above = false;
    if (frontDirection.y > 0.0) {
      above = true;
    }
    num fDotUp = frontDirection.dot(upDirection);
    num pitchAngle = Math.acos(fDotUp);
    num pitchDegrees = degrees(pitchAngle);

    const minPitchAngle = 0.785398163;
    const maxPitchAngle = 2.35619449;
    num minPitchDegrees = degrees(minPitchAngle);
    num maxPitchDegrees = degrees(maxPitchAngle);

    _rotateEyeAndLook(mousePitchDelta, strafeDirection, cam);

    _rotateEyeAndLook(mouseYawDelta, upDirection, cam);
  }

  void _rotateEyeAndLook(num delta_angle, Vector3 axis, Camera cam) {
    quat q = new quat(axis, delta_angle);
    Vector3 frontDirection = cam.frontDirection;
    frontDirection.normalize();
    q.rotate(frontDirection);
    frontDirection.normalize();
    cam.lookAtPosition = cam.eyePosition + frontDirection;
  }
}
