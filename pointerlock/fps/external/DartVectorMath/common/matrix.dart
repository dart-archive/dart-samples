/*

  VectorMath.dart
  
  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>
  
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

/** Returns an OpenGL LookAt matrix */
mat4 makeLookAt(vec3 eyePosition, vec3 lookAtPosition, vec3 upDirection) {
  vec3 z = lookAtPosition - eyePosition;
  z.normalize();
  vec3 x = z.cross(upDirection);
  x.normalize();
  vec3 y = x.cross(z);
  y.normalize();
  mat4 r = new mat4.zero();
  r[0].xyz = x;
  r[1].xyz = y;
  r[2].xyz = -z;
  r[3].w = 1.0;
  r = r.transposed();
  vec3 rotatedEye = r * -eyePosition;
  r[3].xyz = rotatedEye;
  return r;
}

/** Returns an OpenGL perspective camera projection matrix */
mat4 makePerspective(num fov_y_radians, num aspect_ratio, num znear, num zfar) {
  double height = tan(fov_y_radians * 0.5) * znear;
  double width = height * aspect_ratio;

  return makeFrustum(-width, width, -height, height, znear, zfar);
}

/** Returns an OpenGL frustum camera projection matrix */
mat4 makeFrustum(num left, num right, num bottom, num top, num near, num far) {
  num two_near = 2.0 * near;
  num right_minus_left = right - left;
  num top_minus_bottom = top - bottom;
  num far_minus_near = far - near;

  mat4 view = new mat4.zero();
  view[0].x = two_near / right_minus_left;
  view[1].y = two_near / top_minus_bottom;
  view[2].x = (right + left) / right_minus_left;
  view[2].y = (top + bottom) / top_minus_bottom;
  view[2].z = -(far + near) / far_minus_near;
  view[2].w = -1.0;
  view[3].z = -(two_near * far) / far_minus_near;
  view[3].w = 0.0;

  return view;
}

/** Returns an OpenGL orthographic camera projection matrix */ 
mat4 makeOrthographic(num left, num right, num bottom, num top, num znear, num zfar) {
  num rml = right - left;
  num rpl = right + left;
  num tmb = top - bottom;
  num tpb = top + bottom;
  num fmn = zfar - znear;
  num fpn = zfar + znear;
  
  mat4 r = new mat4.zero();
  r[0].x = 2.0/rml;
  r[1].y = 2.0/tmb;
  r[2].z = 2.0/fmn;
  r[3].x = rpl/rml;
  r[3].y = tpb/tmb;
  r[3].z = fpn/fmn;
  r[3].w = 1.0;
  
  return r;
}

/** Returns a transformation matrix that transforms points onto the plane specified with [planeNormal] and [planePoint] */
mat4 makePlaneProjection(vec3 planeNormal, vec3 planePoint) {
  vec4 v = new vec4(planeNormal, 0.0);
  mat4 outer = new mat4.outer(v, v);
  mat4 r = new mat4();
  r = r - outer;
  vec3 scaledNormal = (planeNormal * dot(planePoint, planeNormal));
  vec4 T = new vec4(scaledNormal, 1.0);
  r.col3 = T;
  return r;
}

/** Returns a transformation matrix that transforms points by reflecting them in the plane specified with [planeNormal] and [planePoint] */
mat4 makePlaneReflection(vec3 planeNormal, vec3 planePoint) {
  vec4 v = new vec4(planeNormal, 0.0);
  mat4 outer = new mat4.outer(v,v);
  outer.scale(2.0);
  mat4 r = new mat4();
  r = r - outer;
  num scale = 2.0 * dot(planePoint, planeNormal);
  vec3 scaledNormal = (planeNormal * scale);
  vec4 T = new vec4(scaledNormal, 1.0);
  r.col3 = T;
  return r;
}