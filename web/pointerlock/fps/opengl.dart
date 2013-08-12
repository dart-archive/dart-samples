/*
  Copyright (C) 2013 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

part of fps;

/**
 * Returns an OpenGL look at matrix.
 * The camera is located at [cameraPosition] and is focused
 * on [cameraFocusPostion].
 *
 * The [upDirection] is almost always (0, 1, 0).
 */
Matrix4 makeLookAt(Vector3 cameraPosition, Vector3 cameraFocusPosition, Vector3 upDirection) {
  Vector3 z = cameraPosition - cameraFocusPosition;
  z.normalize();

  Vector3 x = upDirection.cross(z);
  x.normalize();

  Vector3 y = z.cross(x);
  y.normalize();

  Matrix4 r = new Matrix4.zero();
  r.row0 = new Vector4(x.x, x.y, x.z, 0.0);
  r.row1 = new Vector4(y.x, y.y, y.z, 0.0);
  r.row2 = new Vector4(z.x, z.y, z.z, 0.0);
  r.row3 = new Vector4(1.0, 1.0, 1.0, 1.0);

  r = r.transposed();
  Vector3 rotatedEye = r * -cameraPosition;
  r.row3 = new Vector4(rotatedEye.x, rotatedEye.y, rotatedEye.z, 0.0);

  return r;
}

/**
 * Returns an OpenGL perspective camera projection matrix
 * */
Matrix4 makePerspective(double fov_y_radians, double aspect_ratio, double znear, double zfar) {
  double height = Math.tan(fov_y_radians * 0.5) * znear;
  double width = height * aspect_ratio;

  return makeFrustum(-width, width, -height, height, znear, zfar);
}

/**
 * Returns an OpenGL frustum camera projection matrix
 */
Matrix4 makeFrustum(num left, num right, num bottom, num top, num near, num far) {
  double two_near = 2.0 * near;
  double right_minus_left = right - left;
  double top_minus_bottom = top - bottom;
  double far_minus_near = far - near;

  Matrix4 view = new Matrix4.zero();
  //view[0].x = two_near / right_minus_left;
  view.row0 = new Vector4(two_near / right_minus_left, 0.0, 0.0, 0.0);

  // view[1].y = two_near / top_minus_bottom;
  view.row1 = new Vector4(0.0, two_near / top_minus_bottom, 0.0, 0.0);

//  view[2].x = (right + left) / right_minus_left;
//  view[2].y = (top + bottom) / top_minus_bottom;
//  view[2].z = -(far + near) / far_minus_near;
//  view[2].w = -1.0;
  Vector4 row2 = new Vector4((right + left) / right_minus_left,
      (top + bottom) / top_minus_bottom, -(far + near) / far_minus_near, -1.0);
  view.row2 = row2;

//  view[3].z = -(two_near * far) / far_minus_near;
//  view[3].w = 0.0;
  Vector4 row3 = new Vector4(0.0, 0.0, -(two_near * far) / far_minus_near, 0.0);
  view.row3 = row3;

  return view;
}

/**
 * Returns an OpenGL orthographic camera projection matrix
 */
Matrix4 makeOrthographic(double left, double right, double bottom, double top, double znear, double zfar) {
  double rml = right - left;
  double rpl = right + left;
  double tmb = top - bottom;
  double tpb = top + bottom;
  double fmn = zfar - znear;
  double fpn = zfar + znear;

  Matrix4 r = new Matrix4.zero();
//  r[0].x = 2.0/rml;
  r.row0 = new Vector4(2.0/rml, 0.0, 0.0, 0.0);
//  r[1].y = 2.0/tmb;
  r.row1 = new Vector4(0.0, 2.0/tmb, 0.0, 0.0);
//  r[2].z = -2.0/fmn;
  r.row2 = new Vector4(0.0, 0.0, -2.0/fmn, 0.0);
//  r[3].x = -rpl/rml;
//  r[3].y = -tpb/tmb;
//  r[3].z = -fpn/fmn;
//  r[3].w = 1.0;
  r.row3 = new Vector4(-rpl/rml, -tpb/tmb, -fpn/fmn, 1.0);

  return r;
}

/**
 * Returns a transformation matrix that transforms points onto
 * the plane specified with [planeNormal] and [planePoint]
 */
Matrix4 makePlaneProjection(Vector3 planeNormal, Vector3 planePoint) {
  Vector4 v = new Vector4(planeNormal.x, planeNormal.y, planeNormal.z, 0.0);
  Matrix4 outer = new Matrix4.outer(v, v);
  Matrix4 r = new Matrix4.zero();
  r = r - outer;
  //Vector3 scaledNormal = (planeNormal.scaled(dot(planePoint, planeNormal)));
  double d = planePoint.dot(planeNormal);
  Vector3 scaledNormal = planeNormal.scaled(d);
  Vector4 T = new Vector4(scaledNormal.x, scaledNormal.y, scaledNormal.z, 1.0);
  r.setColumn(3, T);
  return r;
}

/**
 * Returns a transformation matrix that transforms points by reflecting
 * them through the plane specified with [planeNormal] and [planePoint]
 */
Matrix4 makePlaneReflection(Vector3 planeNormal, Vector3 planePoint) {
  Vector4 v = new Vector4(planeNormal.x, planeNormal.y, planeNormal.z, 0.0);
  Matrix4 outer = new Matrix4.outer(v,v);
  outer.scale(2.0);
  Matrix4 r = new Matrix4.zero();
  r = r - outer;
//  double scale = 2.0 * dot(planePoint, planeNormal);
  double scale = 2.0 * planePoint.dot(planeNormal);
  Vector3 scaledNormal = (planeNormal.scaled(scale));
  Vector4 T = new Vector4(scaledNormal.x, scaledNormal.y, scaledNormal.z, 1.0);
  r.setColumn(3, T);
  return r;
}

/**
 * On success, Sets [pickWorld] to be the world space position of
 * the screen space [pickX], [pickY], and [pickZ].
 *
 * The viewport is specified by ([viewportX], [viewportWidth]) and
 * ([viewportY], [viewportHeight]).
 *
 * [cameraMatrix] includes both the projection and view transforms.
 *
 * [pickZ] is typically either 0.0 (near plane) or 1.0 (far plane).
 *
 * Returns false on error, for example, the mouse is not in the viewport
 *
 */
bool unproject(Matrix4 cameraMatrix, num viewportX, num viewportWidth,
               num viewportY, num viewportHeight,
               num pickX, num pickY, num pickZ,
               Vector3 pickWorld) {
  pickX = (pickX - viewportX);
  pickY = (pickY - viewportY);
  pickX = (2.0 * pickX / viewportWidth) - 1.0;
  pickY = (2.0 * pickY / viewportHeight) - 1.0;
  pickZ = (2.0 * pickZ) - 1.0;

  // Check if pick point is inside unit cube
  if (pickX < -1.0 || pickY < -1.0 || pickX > 1.0 || pickY > 1.0 ||
      pickZ < -1.0 || pickZ > 1.0) {
    return false;
  }

  // Copy camera matrix.
  Matrix4 invertedCameraMatrix = new Matrix4.copy(cameraMatrix);
  // Invert the camera matrix.
  invertedCameraMatrix.invert();
  // Determine intersection point.
  Vector4 v = new Vector4(pickX, pickY, pickZ, 1.0);
  invertedCameraMatrix.transform(v);
  if (v.w == 0.0) {
    return false;
  }
  double invW = 1.0 / v.w;
  pickWorld.x = v.x * invW;
  pickWorld.y = v.y * invW;
  pickWorld.z = v.z * invW;

  return true;
}

/**
 * On success, [rayNear] and [rayFar] are the points where
 * the screen space [pickX], [pickY] intersect with the near and far
 * planes respectively.
 *
 * The viewport is specified by ([viewportX], [viewportWidth]) and
 * ([viewportY], [viewportHeight]).
 *
 * [cameraMatrix] includes both the projection and view transforms.
 *
 * Returns false on error, for example, the mouse is not in the viewport
 *
 */
bool pickRay(Matrix4 cameraMatrix, num viewportX, num viewportWidth,
               num viewportY, num viewportHeight,
               num pickX, num pickY,
               Vector3 rayNear, Vector3 rayFar) {

  bool r;

  r = unproject(cameraMatrix, viewportX, viewportWidth,
                viewportY, viewportHeight, pickX, viewportHeight-pickY, 0.0, rayNear);
  if (!r) {
    return false;
  }

  r = unproject(cameraMatrix, viewportX, viewportWidth,
                viewportY, viewportHeight, pickX, viewportHeight-pickY, 1.0, rayFar);

  return r;
}