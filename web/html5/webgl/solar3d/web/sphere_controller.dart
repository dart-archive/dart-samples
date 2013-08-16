// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class MouseSphereCameraController {
  double zoomVelocity = 5.0;
  double mouseSensitivity = 360.0;

  double upAngle = 180.0;
  double sideAngle = 0.0;
  double radius = 200.0;

  int accumDX = 0;
  int accumDY = 0;
  int accumScroll = 0;

  final vec3 _origin = new vec3.zero();

  set origin(vec3 o) {
    _origin.copyFrom(o);
  }

  vec3 get origin {
    return _origin.clone();
  }

  double _minRadius = 50.0;
  set minRadius(double r) {
    _minRadius = r;
    if (radius < _minRadius) {
      radius = _minRadius;
    }
  }
  double get minRadius => _minRadius;

  MouseSphereCameraController();

  void updateCamera(num seconds, Camera cam) {
    _zoomView(seconds);
    _orbitView(seconds);
    _updateCamera(cam);
    accumDX = 0;
    accumDY = 0;
    accumScroll = 0;
  }

  void _zoomView(num seconds) {
    double zoomValue = accumScroll.toDouble()*zoomVelocity*seconds;
    radius += zoomValue;
    if (radius < _minRadius) {
      radius = _minRadius;
    }
  }

  void _orbitView(num seconds) {
    num mouseYawDelta = accumDX.toDouble() / mouseSensitivity;
    num mousePitchDelta = accumDY.toDouble() / mouseSensitivity;

    const verticalAngleThreshold = 1.04719;
    sideAngle += mousePitchDelta;
    if (sideAngle < verticalAngleThreshold) {
      sideAngle = verticalAngleThreshold;
    } else if (sideAngle > 2.0*verticalAngleThreshold) {
      sideAngle = 2.0*verticalAngleThreshold;
    }
    upAngle += mouseYawDelta;
  }

  void _updateCamera(Camera cam) {
    cam.lookAtPosition = origin;
    double cosUpAngle = Math.cos(upAngle);
    double sinUpAngle = Math.sin(upAngle);
    double cosSideAngle = Math.cos(sideAngle);
    double sinSideAngle = Math.sin(sideAngle);
    double x = radius * sinSideAngle * cosUpAngle;
    double y = radius * cosSideAngle;
    double z = radius * sinSideAngle * sinUpAngle;
    cam.eyePosition = cam.lookAtPosition + new vec3.raw(x,y,z);
  }
}
