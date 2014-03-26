// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
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

  final Vector3 _origin = new Vector3.zero();

  set origin(Vector3 o) {
    _origin.setFrom(o);
  }

  Vector3 get origin {
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
    var zoomValue = accumScroll.toDouble()*zoomVelocity*seconds;
    radius += zoomValue;
    if (radius < _minRadius) {
      radius = _minRadius;
    }
  }

  void _orbitView(num seconds) {
    var mouseYawDelta = accumDX.toDouble() / mouseSensitivity;
    var mousePitchDelta = accumDY.toDouble() / mouseSensitivity;

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
    var cosUpAngle = Math.cos(upAngle);
    var sinUpAngle = Math.sin(upAngle);
    var cosSideAngle = Math.cos(sideAngle);
    var sinSideAngle = Math.sin(sideAngle);
    var x = radius * sinSideAngle * cosUpAngle;
    var y = radius * cosSideAngle;
    var z = radius * sinSideAngle * sinUpAngle;
    cam.eyePosition = cam.lookAtPosition + new Vector3(x,y,z);
  }
}
