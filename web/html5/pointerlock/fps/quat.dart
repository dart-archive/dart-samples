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

class quat {
  double x;
  double y;
  double z;
  double w;

  /// Constructs a quaternion using the raw values [x], [y], [z], and [w]
  quat.raw(this.x, this.y, this.z, this.w);
  /**
   *  Constructs a new quaternion. Behaviour depends on the types of arguments:
   *
   *  +  *([double] x,[double] y,[double] z,[double] w)* Raw values
   *  +  *([vec3] axis,[double] angle)* Rotation of [angle] degrees around [axis]
   *  +  *([quat] other)* Copy of other
   *  +  *([mat3])* Convert rotation matrix into quaternion
   *
   *
   */
  quat([dynamic a, dynamic b, dynamic c, dynamic d]) {
    x = 0.0;
    y = 0.0;
    z = 0.0;
    w = 1.0;

    if (a is double && b is double && c is double && d is double) {
      x = a;
      y = b;
      z = c;
      w = d;
      return;
    }

    if (a is Vector3 && b is double) {
      setAxisAngle(a, b);
      return;
    }

    if (a is Vector3) {
      x = a.x;
      y = a.y;
      z = a.z;
      w = 0.0;
      return;
    }

    if (a is quat) {
      x = a.x;
      y = a.y;
      z = a.z;
      w = a.w;
      return;
    }

    if (a is Matrix3) {
      double trace = (a as Matrix3).trace();
      if (trace > 0.0) {
        double s = Math.sqrt(trace + 1.0);
        w = s * 0.5;
        s = 0.5 / s;
        x = (a.col1.z - a.col2.y) * s;
        y = (a.col2.x - a.col0.z) * s;
        z = (a.col0.y - a.col1.x) * s;
      } else {
        int i = a.col0.x < a.col1.y ? (a.col1.y < a.col2.z ? 2 : 1) : (a.col0.x < a.col2.z ? 2 : 0);
        int j = (i + 1) % 3;
        int k = (i + 2) % 3;

        double s = Math.sqrt(a[i][i] - a[j][j] - a[k][k] + 1.0);
        this[i] = s * 0.5;
        s = 0.5 / s;
        this[3] = (a[j][k] - a[k][j]) * s;
        this[j] = (a[i][j] + a[j][i]) * s;
        this[k] = (a[i][k] + a[k][i]) * s;
      }
    }
  }

  /// Constructs a new quaternion representing a rotation of [angle] around [axis]
  quat.axisAngle(Vector3 axis, double angle) {
    setAxisAngle(axis, angle);
  }

  /// Constructs a new quaternion which is a copy of [original]
  quat.copy(quat original) {
    x = original.x;
    y = original.y;
    z = original.z;
    w = original.w;
  }

  /** Constructs a random rotation */
  quat.random(Math.Random rn) {
  // From: "Uniform Random Rotations", Ken Shoemake, Graphics Gems III,
  //       pg. 124-132
    double x0 = rn.nextDouble();
    double r1 = Math.sqrt(1.0 - x0);
    double r2 = Math.sqrt(x0);
    double t1 = Math.PI*2.0 * rn.nextDouble();
    double t2 = Math.PI*2.0 * rn.nextDouble();
    double c1 = Math.cos(t1);
    double s1 = Math.sin(t1);
    double c2 = Math.cos(t2);
    double s2 = Math.sin(t2);
    x = s1 * r1;
    y = c1 * r1;
    z = s2 * r2;
    w = c2 * r2;
  }

  /// Constructs the identity quaternion
  quat.identity() {
    x = 0.0;
    y = 0.0;
    z = 0.0;
    w = 1.0;
  }

  /** Constructs the time derivative of [q] with angular velocity [omega] */
  quat.dq(quat q, Vector3 omega) {
    x = omega.x * q.w + omega.y * q.z - omega.z * q.y;
    y = omega.y * q.w + omega.z * q.x - omega.x * q.z;
    z = omega.z * q.w + omega.x * q.y - omega.y * q.x;
    w = -omega.x * q.x - omega.y * q.y - omega.z * q.z;
    x *= 0.5;
    y *= 0.5;
    z *= 0.5;
    w *= 0.5;
  }

  /// Returns a new copy of this
  quat clone() {
    return new quat.copy(this);
  }

  /// Copy [source] into [this]
  void copyFrom(quat source) {
    x = source.x;
    y = source.y;
    z = source.z;
    w = source.w;
  }
  /// Copy [this] into [target]
  void copyTo(quat target) {
    target.x = x;
    target.y = y;
    target.z = z;
    target.w = w;
  }
  /** Set quaternion with rotation of [radians] around [axis] */
  void setAxisAngle(Vector3 axis, double radians) {
    double len = axis.length;
    if (len == 0.0) {
      return;
    }
    double halfSin = Math.sin(radians * 0.5) / len;
    x = axis.x * halfSin;
    y = axis.y * halfSin;
    z = axis.z * halfSin;
    w = Math.cos(radians * 0.5);
  }

  /** Set quaternion with rotation of [yaw], [pitch] and [roll] */
  void setEuler(double yaw, double pitch, double roll) {
    double halfYaw = yaw * 0.5;
    double halfPitch = pitch * 0.5;
    double halfRoll = roll * 0.5;
    double cosYaw = Math.cos(halfYaw);
    double sinYaw = Math.sin(halfYaw);
    double cosPitch = Math.cos(halfPitch);
    double sinPitch = Math.sin(halfPitch);
    double cosRoll = Math.cos(halfRoll);
    double sinRoll = Math.sin(halfRoll);
    x = cosRoll * sinPitch * cosYaw + sinRoll * cosPitch * sinYaw;
    y = cosRoll * cosPitch * sinYaw - sinRoll * sinPitch * cosYaw;
    z = sinRoll * cosPitch * cosYaw - cosRoll * sinPitch * sinYaw;
    w = cosRoll * cosPitch * cosYaw + sinRoll * sinPitch * sinYaw;
  }

  /** Normalize [this] */
  quat normalize() {
    double l = length;
    if (l == 0.0) {
      return this;
    }
    x /= l;
    y /= l;
    z /= l;
    w /= l;
    return this;
  }

  /** Conjugate [this] */
  quat conjugate() {
    x = -x;
    y = -y;
    z = -z;
    w = w;
    return this;
  }

  /** Invert [this]  */
  quat inverse() {
    double l = 1.0 / length2;
    x = -x * l;
    y = -y * l;
    z = -z * l;
    w = w * l;
    return this;
  }

  /** Normalized copy of [this]. Optionally stored in [out]*/
  quat normalized([quat out=null]) {
    if (out == null) {
      out = new quat.copy(this);
    }
    return out.normalize();
  }

  /** Conjugated copy of [this]. Optionally stored in [out] */
  quat conjugated([quat out=null]) {
    if (out == null) {
      out = new quat.copy(this);
    }
    return out.conjugate();
  }

  /** Inverted copy of [this]. Optionally stored in [out] */
  quat inverted([quat out=null]) {
    if (out == null) {
      out = new quat.copy(this);
    }
    return out.inverse();
  }

  /** Radians of rotation */
  double get radians {
    return 2.0 * Math.acos(w);
  }

  /** Axis of rotation */
  Vector3 get axis {
      double divisor = 1.0 - (w*w);
      return new Vector3(x / divisor, y / divisor, z / divisor);
  }

  /** Squared length */
  double get length2 {
    return (x*x) + (y*y) + (z*z) + (w*w);
  }

  /** Length */
  double get length {
    return Math.sqrt(length2);
  }

  /** Returns a copy of [v] rotated by quaternion. Copy optionally stored in [out] */
  Vector3 rotated(Vector3 v, [Vector3 out=null]) {
    if (out == null) {
      out = new Vector3.copy(v);
    } else {
      out.setFrom(v);
    }
    return rotate(out);
  }

  /** Rotates [v] by [this]. Returns [v]. */
  Vector3 rotate(Vector3 v) {
    // conjugate(this) * [v,0] * this
    double tix = -x;
    double tiy = -y;
    double tiz = -z;
    double tiw = w;
    double tx = tiw * v.x + tix * 0.0 + tiy * v.z - tiz * v.y;
    double ty = tiw * v.y + tiy * 0.0 + tiz * v.x - tix * v.z;
    double tz = tiw * v.z + tiz * 0.0 + tix * v.y - tiy * v.x;
    double tw = tiw * 0.0 - tix * v.x - tiy * v.y - tiz * v.z;
    double result_x = tw * x + tx * w + ty * z - tz * y;
    double result_y = tw * y + ty * w + tz * x - tx * z;
    double result_z = tw * z + tz * w + tx * y - ty * x;
    v.x = result_x;
    v.y = result_y;
    v.z = result_z;
    return v;
  }

  /** Return a copy of [this] divided by [scale] */
  quat operator/(double scale) {
    return new quat(x / scale, y / scale, z / scale, w / scale);
  }

  /**  Returns copy of [this] multiplied by [scale]
    *  Returns copy of [this] rotated by [otherQuat]
    */
  quat operator*(dynamic other) {
    if (other is double) {
      return new quat(x * other, y * other, z * other, w * other);
    }
    if (other is quat) {
      return new quat(w * other.x + x * other.w + y * other.z - z * other.y,
                      w * other.y + y * other.w + z * other.x - x * other.z,
                      w * other.z + z * other.w + x * other.y - y * other.x,
                      w * other.w - x * other.x - y * other.y - z * other.z);
    }
  }

  /** Returns copy of [this] - [other] */
  quat operator+(quat other) {
    return new quat(x + other.x, y + other.y, z + other.z, w + other.w);
  }

  /** Returns copy of [this] + [other] */
  quat operator-(quat other) {
    return new quat(x - other.x, y - other.y, z - other.z, w - other.w);
  }

  /** Returns negated copy of [this] */
  quat operator-() {
    return new quat(-x, -y, -z, -w);
  }

  /** Treats [this] as an array and returns [x],[y],[z], or [w] */
  double operator[](int i) {
    assert(i >= 0 && i < 4);
    switch (i) {
    case 0: return x;
    case 1: return y;
    case 2: return z;
    case 3: return w;
    }
    return 0.0;
  }

  /** Treats [this] as an array and assigns [x],[y],[z], or [w] the value of [arg]*/
  void operator[]=(int i, double arg) {
    assert(i >= 0 && i < 4);
    switch (i) {
    case 0: x = arg; break;
    case 1: y = arg; break;
    case 2: z = arg; break;
    case 3: w = arg; break;
    }
  }

  /** Returns a rotation matrix containing the same rotation as [this] */
  Matrix3 asRotationMatrix() {
    double d = length2;
    assert(d != 0.0);
    double s = 2.0 / d;

    double xs = x * s;
    double ys = y * s;
    double zs = z * s;

    double wx = w * xs;
    double wy = w * ys;
    double wz = w * zs;

    double xx = x * xs;
    double xy = x * ys;
    double xz = x * zs;

    double yy = y * ys;
    double yz = y * zs;
    double zz = z * zs;

    return new Matrix3(1.0 - (yy + zz), xy + wz, xz - wy, // column 0
      xy - wz, 1.0 - (xx + zz), yz + wx, // column 1
      xz + wy, yz - wx, 1.0 - (xx + yy) // column 2
      );
  }

  /** Returns a printable string */
  String toString() {
    return '$x, $y, $z @ $w';
  }

  /** Returns relative error between [this]  and [correct] */
  double relativeError(quat correct) {
    quat diff = correct - this;
    double norm_diff = diff.length;
    double correct_norm = correct.length;
    return norm_diff/correct_norm;
  }

  /** Returns absolute error between [this] and [correct] */
  double absoluteError(quat correct) {
    double this_norm = length;
    double correct_norm = correct.length;
    double norm_diff = (this_norm - correct_norm).abs();
    return norm_diff;
  }
}