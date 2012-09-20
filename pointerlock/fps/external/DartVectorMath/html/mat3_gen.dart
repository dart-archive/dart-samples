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
/// mat3 is a column major matrix where each column is represented by [vec3]. This matrix has 3 columns and 3 rows.
class mat3 {
  vec3 col0;
  vec3 col1;
  vec3 col2;
  /// Constructs a new mat3. Supports GLSL like syntax so many possible inputs. Defaults to identity matrix.
  mat3([Dynamic arg0, Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4, Dynamic arg5, Dynamic arg6, Dynamic arg7, Dynamic arg8]) {
    //Initialize the matrix as the identity matrix
    col0 = new vec3.zero();
    col1 = new vec3.zero();
    col2 = new vec3.zero();
    col0.x = 1.0;
    col1.y = 1.0;
    col2.z = 1.0;
    if (arg0 is num && arg1 is num && arg2 is num && arg3 is num && arg4 is num && arg5 is num && arg6 is num && arg7 is num && arg8 is num) {
      col0.x = arg0;
      col0.y = arg1;
      col0.z = arg2;
      col1.x = arg3;
      col1.y = arg4;
      col1.z = arg5;
      col2.x = arg6;
      col2.y = arg7;
      col2.z = arg8;
      return;
    }
    if (arg0 is num && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null) {
      col0.x = arg0;
      col1.y = arg0;
      col2.z = arg0;
      return;
    }
    if (arg0 is vec3 && arg1 is vec3 && arg2 is vec3) {
      col0 = arg0;
      col1 = arg1;
      col2 = arg2;
      return;
    }
    if (arg0 is mat3) {
      col0 = arg0.col0;
      col1 = arg0.col1;
      col2 = arg0.col2;
      return;
    }
    if (arg0 is mat2) {
      col0.x = arg0.col0.x;
      col0.y = arg0.col0.y;
      col1.x = arg0.col1.x;
      col1.y = arg0.col1.y;
      return;
    }
    if (arg0 is vec2 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
    }
    if (arg0 is vec3 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
      col2.z = arg0.z;
    }
  }
  /// Constructs a new [mat3] from computing the outer product of [u] and [v].
  mat3.outer(vec3 u, vec3 v) {
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col0.x = u.x * v.x;
    col0.y = u.x * v.y;
    col0.z = u.x * v.z;
    col1.x = u.y * v.x;
    col1.y = u.y * v.y;
    col1.z = u.y * v.z;
    col2.x = u.z * v.x;
    col2.y = u.z * v.y;
    col2.z = u.z * v.z;
  }
  /// Constructs a new [mat3] filled with zeros.
  mat3.zero() {
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col0.x = 0.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col1.x = 0.0;
    col1.y = 0.0;
    col1.z = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 0.0;
  }
  /// Constructs a new identity [mat3].
  mat3.identity() {
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col0.x = 1.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col1.x = 0.0;
    col1.y = 1.0;
    col1.z = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 1.0;
  }
  /// Constructs a new [mat3] which is a copy of [other].
  mat3.copy(mat3 other) {
    col0 = new vec3();
    col1 = new vec3();
    col2 = new vec3();
    col0.x = other.col0.x;
    col0.y = other.col0.y;
    col0.z = other.col0.z;
    col1.x = other.col1.x;
    col1.y = other.col1.y;
    col1.z = other.col1.z;
    col2.x = other.col2.x;
    col2.y = other.col2.y;
    col2.z = other.col2.z;
  }
  //// Constructs a new [mat3] representation a rotation of [radians] around the X axis
  mat3.rotationX(num radians_) {
    col0 = new vec3.zero();
    col1 = new vec3.zero();
    col2 = new vec3.zero();
    setRotationX(radians_);
  }
  //// Constructs a new [mat3] representation a rotation of [radians] around the Y axis
  mat3.rotationY(num radians_) {
    col0 = new vec3.zero();
    col1 = new vec3.zero();
    col2 = new vec3.zero();
    setRotationY(radians_);
  }
  //// Constructs a new [mat3] representation a rotation of [radians] around the Z axis
  mat3.rotationZ(num radians_) {
    col0 = new vec3.zero();
    col1 = new vec3.zero();
    col2 = new vec3.zero();
    setRotationZ(radians_);
  }
  mat3.raw(num arg0, num arg1, num arg2, num arg3, num arg4, num arg5, num arg6, num arg7, num arg8) {
    col0 = new vec3.zero();
    col1 = new vec3.zero();
    col2 = new vec3.zero();
    col0.x = arg0;
    col0.y = arg1;
    col0.z = arg2;
    col1.x = arg3;
    col1.y = arg4;
    col1.z = arg5;
    col2.x = arg6;
    col2.y = arg7;
    col2.z = arg8;
  }
  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    s = '$s[2] ${getRow(2)}\n';
    return s;
  }
  /// Returns the number of rows in the matrix.
  num get rows() => 3;
  /// Returns the number of columns in the matrix.
  num get cols() => 3;
  /// Returns the number of columns in the matrix.
  num get length() => 3;
  /// Gets the [column] of the matrix
  vec3 operator[](int column) {
    assert(column >= 0 && column < 3);
    switch (column) {
      case 0: return col0;
      case 1: return col1;
      case 2: return col2;
    }
    throw new IllegalArgumentException(column);
  }
  /// Assigns the [column] of the matrix [arg]
  void operator[]=(int column, vec3 arg) {
    assert(column >= 0 && column < 3);
    switch (column) {
      case 0: col0 = arg; break;
      case 1: col1 = arg; break;
      case 2: col2 = arg; break;
    }
    throw new IllegalArgumentException(column);
  }
  /// Returns row 0
  vec3 get row0() => getRow(0);
  /// Returns row 1
  vec3 get row1() => getRow(1);
  /// Returns row 2
  vec3 get row2() => getRow(2);
  /// Sets row 0 to [arg]
  set row0(vec3 arg) => setRow(0, arg);
  /// Sets row 1 to [arg]
  set row1(vec3 arg) => setRow(1, arg);
  /// Sets row 2 to [arg]
  set row2(vec3 arg) => setRow(2, arg);
  /// Assigns the [column] of the matrix [arg]
  void setRow(int row, vec3 arg) {
    assert(row >= 0 && row < 3);
    col0[row] = arg.x;
    col1[row] = arg.y;
    col2[row] = arg.z;
  }
  /// Gets the [row] of the matrix
  vec3 getRow(int row) {
    assert(row >= 0 && row < 3);
    vec3 r = new vec3();
    r.x = col0[row];
    r.y = col1[row];
    r.z = col2[row];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec3 arg) {
    assert(column >= 0 && column < 3);
    this[column] = arg;
  }
  /// Gets the [column] of the matrix
  vec3 getColumn(int column) {
    assert(column >= 0 && column < 3);
    return new vec3(this[column]);
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat3 r = new mat3.zero();
      r.col0.x = col0.x * arg;
      r.col0.y = col0.y * arg;
      r.col0.z = col0.z * arg;
      r.col1.x = col1.x * arg;
      r.col1.y = col1.y * arg;
      r.col1.z = col1.z * arg;
      r.col2.x = col2.x * arg;
      r.col2.y = col2.y * arg;
      r.col2.z = col2.z * arg;
      return r;
    }
    if (arg is vec3) {
      vec3 r = new vec3.zero();
      r.x =  (this.col0.x * arg.x) + (this.col1.x * arg.y) + (this.col2.x * arg.z);
      r.y =  (this.col0.y * arg.x) + (this.col1.y * arg.y) + (this.col2.y * arg.z);
      r.z =  (this.col0.z * arg.x) + (this.col1.z * arg.y) + (this.col2.z * arg.z);
      return r;
    }
    if (3 == arg.rows) {
      Dynamic r = null;
      if (arg.cols == 3) {
        r = new mat3.zero();
        r.col0.x =  (this.col0.x * arg.col0.x) + (this.col1.x * arg.col0.y) + (this.col2.x * arg.col0.z);
        r.col1.x =  (this.col0.x * arg.col1.x) + (this.col1.x * arg.col1.y) + (this.col2.x * arg.col1.z);
        r.col2.x =  (this.col0.x * arg.col2.x) + (this.col1.x * arg.col2.y) + (this.col2.x * arg.col2.z);
        r.col0.y =  (this.col0.y * arg.col0.x) + (this.col1.y * arg.col0.y) + (this.col2.y * arg.col0.z);
        r.col1.y =  (this.col0.y * arg.col1.x) + (this.col1.y * arg.col1.y) + (this.col2.y * arg.col1.z);
        r.col2.y =  (this.col0.y * arg.col2.x) + (this.col1.y * arg.col2.y) + (this.col2.y * arg.col2.z);
        r.col0.z =  (this.col0.z * arg.col0.x) + (this.col1.z * arg.col0.y) + (this.col2.z * arg.col0.z);
        r.col1.z =  (this.col0.z * arg.col1.x) + (this.col1.z * arg.col1.y) + (this.col2.z * arg.col1.z);
        r.col2.z =  (this.col0.z * arg.col2.x) + (this.col1.z * arg.col2.y) + (this.col2.z * arg.col2.z);
        return r;
      }
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat3 operator+(mat3 arg) {
    mat3 r = new mat3();
    r.col0.x = col0.x + arg.col0.x;
    r.col0.y = col0.y + arg.col0.y;
    r.col0.z = col0.z + arg.col0.z;
    r.col1.x = col1.x + arg.col1.x;
    r.col1.y = col1.y + arg.col1.y;
    r.col1.z = col1.z + arg.col1.z;
    r.col2.x = col2.x + arg.col2.x;
    r.col2.y = col2.y + arg.col2.y;
    r.col2.z = col2.z + arg.col2.z;
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat3 operator-(mat3 arg) {
    mat3 r = new mat3();
    r.col0.x = col0.x - arg.col0.x;
    r.col0.y = col0.y - arg.col0.y;
    r.col0.z = col0.z - arg.col0.z;
    r.col1.x = col1.x - arg.col1.x;
    r.col1.y = col1.y - arg.col1.y;
    r.col1.z = col1.z - arg.col1.z;
    r.col2.x = col2.x - arg.col2.x;
    r.col2.y = col2.y - arg.col2.y;
    r.col2.z = col2.z - arg.col2.z;
    return r;
  }
  /// Returns new matrix -this
  mat3 operator -() {
    mat3 r = new mat3();
    r[0] = -this[0];
    r[1] = -this[1];
    r[2] = -this[2];
    return r;
  }
  /// Zeros [this].
  mat3 setZero() {
    col0.x = 0.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col1.x = 0.0;
    col1.y = 0.0;
    col1.z = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 0.0;
    return this;
  }
  /// Makes [this] into the identity matrix.
  mat3 setIdentity() {
    col0.x = 1.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col1.x = 0.0;
    col1.y = 1.0;
    col1.z = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 1.0;
    return this;
  }
  /// Returns the tranpose of this.
  mat3 transposed() {
    mat3 r = new mat3();
    r.col0.x = col0.x;
    r.col0.y = col1.x;
    r.col0.z = col2.x;
    r.col1.x = col0.y;
    r.col1.y = col1.y;
    r.col1.z = col2.y;
    r.col2.x = col0.z;
    r.col2.y = col1.z;
    r.col2.z = col2.z;
    return r;
  }
  /// Returns the component wise absolute value of this.
  mat3 absolute() {
    mat3 r = new mat3();
    r.col0.x = col0.x.abs();
    r.col0.y = col0.y.abs();
    r.col0.z = col0.z.abs();
    r.col1.x = col1.x.abs();
    r.col1.y = col1.y.abs();
    r.col1.z = col1.z.abs();
    r.col2.x = col2.x.abs();
    r.col2.y = col2.y.abs();
    r.col2.z = col2.z.abs();
    return r;
  }
  /// Returns the determinant of this matrix.
  num determinant() {
    num x = col0.x*((col1.y*col2.z)-(col1.z*col2.y));
    num y = col0.y*((col1.x*col2.z)-(col1.z*col2.x));
    num z = col0.z*((col1.x*col2.y)-(col1.y*col2.x));
    return x - y + z;
  }
  /// Returns the trace of the matrix. The trace of a matrix is the sum of the diagonal entries
  num trace() {
    num t = 0.0;
    t += col0.x;
    t += col1.y;
    t += col2.z;
    return t;
  }
  /// Returns infinity norm of the matrix. Used for numerical analysis.
  num infinityNorm() {
    num norm = 0.0;
    {
      num row_norm = 0.0;
      row_norm += this[0][0].abs();
      row_norm += this[0][1].abs();
      row_norm += this[0][2].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[1][0].abs();
      row_norm += this[1][1].abs();
      row_norm += this[1][2].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[2][0].abs();
      row_norm += this[2][1].abs();
      row_norm += this[2][2].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  /// Returns relative error between [this] and [correct]
  num relativeError(mat3 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  /// Returns absolute error between [this] and [correct]
  num absoluteError(mat3 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  /// Invert the matrix. Returns the determinant.
  num invert() {
    num det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    num invDet = 1.0 / det;
    vec3 i = new vec3.zero();
    vec3 j = new vec3.zero();
    vec3 k = new vec3.zero();
    i.x = invDet * (col1.y * col2.z - col1.z * col2.y);
    i.y = invDet * (col0.z * col2.y - col0.y * col2.z);
    i.z = invDet * (col0.y * col1.z - col0.z * col1.y);
    j.x = invDet * (col1.z * col2.x - col1.x * col2.z);
    j.y = invDet * (col0.x * col2.z - col0.z * col2.x);
    j.z = invDet * (col0.z * col1.x - col0.x * col1.z);
    k.x = invDet * (col1.x * col2.y - col1.y * col2.x);
    k.y = invDet * (col0.y * col2.x - col0.x * col2.y);
    k.z = invDet * (col0.x * col1.y - col0.y * col1.x);
    col0 = i;
    col1 = j;
    col2 = k;
    return det;
  }
  /// Turns the matrix into a rotation of [radians] around X
  void setRotationX(num radians_) {
    num c = Math.cos(radians_);
    num s = Math.sin(radians_);
    col0.x = 1.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col1.x = 0.0;
    col1.y = c;
    col1.z = s;
    col2.x = 0.0;
    col2.y = -s;
    col2.z = c;
  }
  /// Turns the matrix into a rotation of [radians] around Y
  void setRotationY(num radians_) {
    num c = Math.cos(radians_);
    num s = Math.sin(radians_);
    col0.x = c;
    col0.y = 0.0;
    col0.z = s;
    col1.x = 0.0;
    col1.y = 1.0;
    col1.z = 0.0;
    col2.x = -s;
    col2.y = 0.0;
    col2.z = c;
  }
  /// Turns the matrix into a rotation of [radians] around Z
  void setRotationZ(num radians_) {
    num c = Math.cos(radians_);
    num s = Math.sin(radians_);
    col0.x = c;
    col0.y = s;
    col0.z = 0.0;
    col1.x = -s;
    col1.y = c;
    col1.z = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 1.0;
  }
  /// Converts into Adjugate matrix and scales by [scale]
  mat3 scaleAdjoint(num scale_) {
    num m00 = col0.x;
    num m01 = col1.x;
    num m02 = col2.x;
    num m10 = col0.y;
    num m11 = col1.y;
    num m12 = col2.y;
    num m20 = col0.z;
    num m21 = col1.z;
    num m22 = col2.z;
    col0.x = (m11 * m22 - m12 * m21) * scale_;
    col0.y = (m12 * m20 - m10 * m22) * scale_;
    col0.z = (m10 * m21 - m11 * m20) * scale_;
    col1.x = (m02 * m21 - m01 * m22) * scale_;
    col1.y = (m00 * m22 - m02 * m20) * scale_;
    col1.z = (m01 * m20 - m00 * m21) * scale_;
    col2.x = (m01 * m12 - m02 * m11) * scale_;
    col2.y = (m02 * m10 - m00 * m12) * scale_;
    col2.z = (m00 * m00 - m01 * m10) * scale_;
    return this;
  }
  /// Rotates [arg] by the absolute rotation of [this]
  /// Returns [arg].
  /// Primarily used by AABB transformation code.
  vec3 absoluteRotate(vec3 arg) {
    num m00 = col0.x.abs();
    num m01 = col1.x.abs();
    num m02 = col2.x.abs();
    num m10 = col0.y.abs();
    num m11 = col1.y.abs();
    num m12 = col2.y.abs();
    num m20 = col0.z.abs();
    num m21 = col1.z.abs();
    num m22 = col2.z.abs();
    num x = arg.x;
    num y = arg.y;
    num z = arg.z;
    arg.x = x * m00 + y * m01 + z * m02 + 0.0 * 0.0;
    arg.y = x * m10 + y * m11 + z * m12 + 0.0 * 0.0;
    arg.z = x * m20 + y * m21 + z * m22 + 0.0 * 0.0;
    return arg;
  }
  mat3 newCopy() {
    return new mat3.copy(this);
  }
  mat3 copyInto(mat3 arg) {
    arg.col0.x = col0.x;
    arg.col0.y = col0.y;
    arg.col0.z = col0.z;
    arg.col1.x = col1.x;
    arg.col1.y = col1.y;
    arg.col1.z = col1.z;
    arg.col2.x = col2.x;
    arg.col2.y = col2.y;
    arg.col2.z = col2.z;
    return arg;
  }
  mat3 copyFrom(mat3 arg) {
    col0.x = arg.col0.x;
    col0.y = arg.col0.y;
    col0.z = arg.col0.z;
    col1.x = arg.col1.x;
    col1.y = arg.col1.y;
    col1.z = arg.col1.z;
    col2.x = arg.col2.x;
    col2.y = arg.col2.y;
    col2.z = arg.col2.z;
    return this;
  }
  mat3 add(mat3 o) {
    col0.x = col0.x + o.col0.x;
    col0.y = col0.y + o.col0.y;
    col0.z = col0.z + o.col0.z;
    col1.x = col1.x + o.col1.x;
    col1.y = col1.y + o.col1.y;
    col1.z = col1.z + o.col1.z;
    col2.x = col2.x + o.col2.x;
    col2.y = col2.y + o.col2.y;
    col2.z = col2.z + o.col2.z;
    return this;
  }
  mat3 sub(mat3 o) {
    col0.x = col0.x - o.col0.x;
    col0.y = col0.y - o.col0.y;
    col0.z = col0.z - o.col0.z;
    col1.x = col1.x - o.col1.x;
    col1.y = col1.y - o.col1.y;
    col1.z = col1.z - o.col1.z;
    col2.x = col2.x - o.col2.x;
    col2.y = col2.y - o.col2.y;
    col2.z = col2.z - o.col2.z;
    return this;
  }
  mat3 negate() {
    col0.x = -col0.x;
    col0.y = -col0.y;
    col0.z = -col0.z;
    col1.x = -col1.x;
    col1.y = -col1.y;
    col1.z = -col1.z;
    col2.x = -col2.x;
    col2.y = -col2.y;
    col2.z = -col2.z;
    return this;
  }
  mat3 multiply(mat3 arg) {
    final num m00 = col0.x;
    final num m01 = col1.x;
    final num m02 = col2.x;
    final num m10 = col0.y;
    final num m11 = col1.y;
    final num m12 = col2.y;
    final num m20 = col0.z;
    final num m21 = col1.z;
    final num m22 = col2.z;
    final num n00 = arg.col0.x;
    final num n01 = arg.col1.x;
    final num n02 = arg.col2.x;
    final num n10 = arg.col0.y;
    final num n11 = arg.col1.y;
    final num n12 = arg.col2.y;
    final num n20 = arg.col0.z;
    final num n21 = arg.col1.z;
    final num n22 = arg.col2.z;
    col0.x =  (m00 * n00) + (m01 * n10) + (m02 * n20);
    col1.x =  (m00 * n01) + (m01 * n11) + (m02 * n21);
    col2.x =  (m00 * n02) + (m01 * n12) + (m02 * n22);
    col0.y =  (m10 * n00) + (m11 * n10) + (m12 * n20);
    col1.y =  (m10 * n01) + (m11 * n11) + (m12 * n21);
    col2.y =  (m10 * n02) + (m11 * n12) + (m12 * n22);
    col0.z =  (m20 * n00) + (m21 * n10) + (m22 * n20);
    col1.z =  (m20 * n01) + (m21 * n11) + (m22 * n21);
    col2.z =  (m20 * n02) + (m21 * n12) + (m22 * n22);
    return this;
  }
  mat3 transposeMultiply(mat3 arg) {
    num m00 = col0.x;
    num m01 = col0.y;
    num m02 = col0.z;
    num m10 = col1.x;
    num m11 = col1.y;
    num m12 = col1.z;
    num m20 = col2.x;
    num m21 = col2.y;
    num m22 = col2.z;
    col0.x =  (m00 * arg.col0.x) + (m01 * arg.col0.y) + (m02 * arg.col0.z);
    col1.x =  (m00 * arg.col1.x) + (m01 * arg.col1.y) + (m02 * arg.col1.z);
    col2.x =  (m00 * arg.col2.x) + (m01 * arg.col2.y) + (m02 * arg.col2.z);
    col0.y =  (m10 * arg.col0.x) + (m11 * arg.col0.y) + (m12 * arg.col0.z);
    col1.y =  (m10 * arg.col1.x) + (m11 * arg.col1.y) + (m12 * arg.col1.z);
    col2.y =  (m10 * arg.col2.x) + (m11 * arg.col2.y) + (m12 * arg.col2.z);
    col0.z =  (m20 * arg.col0.x) + (m21 * arg.col0.y) + (m22 * arg.col0.z);
    col1.z =  (m20 * arg.col1.x) + (m21 * arg.col1.y) + (m22 * arg.col1.z);
    col2.z =  (m20 * arg.col2.x) + (m21 * arg.col2.y) + (m22 * arg.col2.z);
    return this;
  }
  mat3 multiplyTranspose(mat3 arg) {
    num m00 = col0.x;
    num m01 = col1.x;
    num m02 = col2.x;
    num m10 = col0.y;
    num m11 = col1.y;
    num m12 = col2.y;
    num m20 = col0.z;
    num m21 = col1.z;
    num m22 = col2.z;
    col0.x =  (m00 * arg.col0.x) + (m01 * arg.col1.x) + (m02 * arg.col2.x);
    col1.x =  (m00 * arg.col0.y) + (m01 * arg.col1.y) + (m02 * arg.col2.y);
    col2.x =  (m00 * arg.col0.z) + (m01 * arg.col1.z) + (m02 * arg.col2.z);
    col0.y =  (m10 * arg.col0.x) + (m11 * arg.col1.x) + (m12 * arg.col2.x);
    col1.y =  (m10 * arg.col0.y) + (m11 * arg.col1.y) + (m12 * arg.col2.y);
    col2.y =  (m10 * arg.col0.z) + (m11 * arg.col1.z) + (m12 * arg.col2.z);
    col0.z =  (m20 * arg.col0.x) + (m21 * arg.col1.x) + (m22 * arg.col2.x);
    col1.z =  (m20 * arg.col0.y) + (m21 * arg.col1.y) + (m22 * arg.col2.y);
    col2.z =  (m20 * arg.col0.z) + (m21 * arg.col1.z) + (m22 * arg.col2.z);
    return this;
  }
  vec3 transform(vec3 arg) {
    num x_ =  (this.col0.x * arg.x) + (this.col1.x * arg.y) + (this.col2.x * arg.z);
    num y_ =  (this.col0.y * arg.x) + (this.col1.y * arg.y) + (this.col2.y * arg.z);
    num z_ =  (this.col0.z * arg.x) + (this.col1.z * arg.y) + (this.col2.z * arg.z);
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    return arg;
  }
  vec3 transformed(vec3 arg, [vec3 out=null]) {
    if (out == null) {
      out = new vec3.copy(arg);
    } else {
      out.copyFrom(arg);
    }
    return transform(out);
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(Float32Array array, [int offset=0]) {
    int i = offset;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col0.z;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col1.z;
    i++;
    array[i] = col2.x;
    i++;
    array[i] = col2.y;
    i++;
    array[i] = col2.z;
    i++;
  }
  /// Returns a copy of [this] as a [Float32Array].
  Float32Array copyAsArray() {
    Float32Array array = new Float32Array(9);
    int i = 0;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col0.z;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col1.z;
    i++;
    array[i] = col2.x;
    i++;
    array[i] = col2.y;
    i++;
    array[i] = col2.z;
    i++;
    return array;
  }
  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(Float32Array array, [int offset=0]) {
    int i = offset;
    col0.x = array[i];
    i++;
    col0.y = array[i];
    i++;
    col0.z = array[i];
    i++;
    col1.x = array[i];
    i++;
    col1.y = array[i];
    i++;
    col1.z = array[i];
    i++;
    col2.x = array[i];
    i++;
    col2.y = array[i];
    i++;
    col2.z = array[i];
    i++;
  }
  vec3 get right() {
    vec3 f = new vec3.zero();
    f.x = col0.x;
    f.y = col0.y;
    f.z = col0.z;
    return f;
  }
  vec3 get up() {
    vec3 f = new vec3.zero();
    f.x = col1.x;
    f.y = col1.y;
    f.z = col1.z;
    return f;
  }
  vec3 get forward() {
    vec3 f = new vec3.zero();
    f.x = col2.x;
    f.y = col2.y;
    f.z = col2.z;
    return f;
  }
}
