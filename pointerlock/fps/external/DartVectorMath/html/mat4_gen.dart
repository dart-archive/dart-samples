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
/// mat4 is a column major matrix where each column is represented by [vec4]. This matrix has 4 columns and 4 rows.
class mat4 {
  vec4 col0;
  vec4 col1;
  vec4 col2;
  vec4 col3;
  /// Constructs a new mat4. Supports GLSL like syntax so many possible inputs. Defaults to identity matrix.
  mat4([Dynamic arg0, Dynamic arg1, Dynamic arg2, Dynamic arg3, Dynamic arg4, Dynamic arg5, Dynamic arg6, Dynamic arg7, Dynamic arg8, Dynamic arg9, Dynamic arg10, Dynamic arg11, Dynamic arg12, Dynamic arg13, Dynamic arg14, Dynamic arg15]) {
    //Initialize the matrix as the identity matrix
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col2 = new vec4.zero();
    col3 = new vec4.zero();
    col0.x = 1.0;
    col1.y = 1.0;
    col2.z = 1.0;
    col3.w = 1.0;
    if (arg0 is num && arg1 is num && arg2 is num && arg3 is num && arg4 is num && arg5 is num && arg6 is num && arg7 is num && arg8 is num && arg9 is num && arg10 is num && arg11 is num && arg12 is num && arg13 is num && arg14 is num && arg15 is num) {
      col0.x = arg0;
      col0.y = arg1;
      col0.z = arg2;
      col0.w = arg3;
      col1.x = arg4;
      col1.y = arg5;
      col1.z = arg6;
      col1.w = arg7;
      col2.x = arg8;
      col2.y = arg9;
      col2.z = arg10;
      col2.w = arg11;
      col3.x = arg12;
      col3.y = arg13;
      col3.z = arg14;
      col3.w = arg15;
      return;
    }
    if (arg0 is num && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null && arg9 == null && arg10 == null && arg11 == null && arg12 == null && arg13 == null && arg14 == null && arg15 == null) {
      col0.x = arg0;
      col1.y = arg0;
      col2.z = arg0;
      col3.w = arg0;
      return;
    }
    if (arg0 is vec4 && arg1 is vec4 && arg2 is vec4 && arg3 is vec4) {
      col0 = arg0;
      col1 = arg1;
      col2 = arg2;
      col3 = arg3;
      return;
    }
    if (arg0 is mat4) {
      col0 = arg0.col0;
      col1 = arg0.col1;
      col2 = arg0.col2;
      col3 = arg0.col3;
      return;
    }
    if (arg0 is mat3) {
      col0.x = arg0.col0.x;
      col0.y = arg0.col0.y;
      col0.z = arg0.col0.z;
      col1.x = arg0.col1.x;
      col1.y = arg0.col1.y;
      col1.z = arg0.col1.z;
      col2.x = arg0.col2.x;
      col2.y = arg0.col2.y;
      col2.z = arg0.col2.z;
      return;
    }
    if (arg0 is mat2) {
      col0.x = arg0.col0.x;
      col0.y = arg0.col0.y;
      col1.x = arg0.col1.x;
      col1.y = arg0.col1.y;
      return;
    }
    if (arg0 is vec2 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null && arg9 == null && arg10 == null && arg11 == null && arg12 == null && arg13 == null && arg14 == null && arg15 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
    }
    if (arg0 is vec3 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null && arg9 == null && arg10 == null && arg11 == null && arg12 == null && arg13 == null && arg14 == null && arg15 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
      col2.z = arg0.z;
    }
    if (arg0 is vec4 && arg1 == null && arg2 == null && arg3 == null && arg4 == null && arg5 == null && arg6 == null && arg7 == null && arg8 == null && arg9 == null && arg10 == null && arg11 == null && arg12 == null && arg13 == null && arg14 == null && arg15 == null) {
      col0.x = arg0.x;
      col1.y = arg0.y;
      col2.z = arg0.z;
      col3.w = arg0.w;
    }
  }
  /// Constructs a new [mat4] from computing the outer product of [u] and [v].
  mat4.outer(vec4 u, vec4 v) {
    col0 = new vec4();
    col1 = new vec4();
    col2 = new vec4();
    col3 = new vec4();
    col0.x = u.x * v.x;
    col0.y = u.x * v.y;
    col0.z = u.x * v.z;
    col0.w = u.x * v.w;
    col1.x = u.y * v.x;
    col1.y = u.y * v.y;
    col1.z = u.y * v.z;
    col1.w = u.y * v.w;
    col2.x = u.z * v.x;
    col2.y = u.z * v.y;
    col2.z = u.z * v.z;
    col2.w = u.z * v.w;
    col3.x = u.w * v.x;
    col3.y = u.w * v.y;
    col3.z = u.w * v.z;
    col3.w = u.w * v.w;
  }
  /// Constructs a new [mat4] filled with zeros.
  mat4.zero() {
    col0 = new vec4();
    col1 = new vec4();
    col2 = new vec4();
    col3 = new vec4();
    col0.x = 0.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col0.w = 0.0;
    col1.x = 0.0;
    col1.y = 0.0;
    col1.z = 0.0;
    col1.w = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 0.0;
    col2.w = 0.0;
    col3.x = 0.0;
    col3.y = 0.0;
    col3.z = 0.0;
    col3.w = 0.0;
  }
  /// Constructs a new identity [mat4].
  mat4.identity() {
    col0 = new vec4();
    col1 = new vec4();
    col2 = new vec4();
    col3 = new vec4();
    col0.x = 1.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col0.w = 0.0;
    col1.x = 0.0;
    col1.y = 1.0;
    col1.z = 0.0;
    col1.w = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 1.0;
    col2.w = 0.0;
    col3.x = 0.0;
    col3.y = 0.0;
    col3.z = 0.0;
    col3.w = 1.0;
  }
  /// Constructs a new [mat4] which is a copy of [other].
  mat4.copy(mat4 other) {
    col0 = new vec4();
    col1 = new vec4();
    col2 = new vec4();
    col3 = new vec4();
    col0.x = other.col0.x;
    col0.y = other.col0.y;
    col0.z = other.col0.z;
    col0.w = other.col0.w;
    col1.x = other.col1.x;
    col1.y = other.col1.y;
    col1.z = other.col1.z;
    col1.w = other.col1.w;
    col2.x = other.col2.x;
    col2.y = other.col2.y;
    col2.z = other.col2.z;
    col2.w = other.col2.w;
    col3.x = other.col3.x;
    col3.y = other.col3.y;
    col3.z = other.col3.z;
    col3.w = other.col3.w;
  }
  //// Constructs a new [mat4] representation a rotation of [radians] around the X axis
  mat4.rotationX(num radians_) {
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col2 = new vec4.zero();
    col3 = new vec4.zero();
    col3.w = 1.0;
    setRotationX(radians_);
  }
  //// Constructs a new [mat4] representation a rotation of [radians] around the Y axis
  mat4.rotationY(num radians_) {
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col2 = new vec4.zero();
    col3 = new vec4.zero();
    col3.w = 1.0;
    setRotationY(radians_);
  }
  //// Constructs a new [mat4] representation a rotation of [radians] around the Z axis
  mat4.rotationZ(num radians_) {
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col2 = new vec4.zero();
    col3 = new vec4.zero();
    col3.w = 1.0;
    setRotationZ(radians_);
  }
  /// Constructs a new [mat4] translation matrix from [translation]
  mat4.translation(vec3 translation) {
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col2 = new vec4.zero();
    col3 = new vec4.zero();
    col0.x = 1.0;
    col1.y = 1.0;
    col2.z = 1.0;
    col3.w = 1.0;
    col3.xyz = translation;
  }
  /// Constructs a new [mat4] translation from [x], [y], and [z]
  mat4.translationRaw(num x, num y, num z) {
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col2 = new vec4.zero();
    col3 = new vec4.zero();
    col0.x = 1.0;
    col1.y = 1.0;
    col2.z = 1.0;
    col3.w = 1.0;
    col3.x = x;
    col3.y = y;
    col3.z = z;
  }
  //// Constructs a new [mat4] scale of [x], [y], and [z]
  mat4.scaleVec(vec3 scale_) {
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col2 = new vec4.zero();
    col3 = new vec4.zero();
    col0.x = scale_.x;
    col1.y = scale_.y;
    col2.z = scale_.z;
    col3.w = 1.0;
  }
  //// Constructs a new [mat4] representening a scale of [x], [y], and [z]
  mat4.scaleRaw(num x, num y, num z) {
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col2 = new vec4.zero();
    col3 = new vec4.zero();
    col0.x = x;
    col1.y = y;
    col2.z = z;
    col3.w = 1.0;
  }
  mat4.raw(num arg0, num arg1, num arg2, num arg3, num arg4, num arg5, num arg6, num arg7, num arg8, num arg9, num arg10, num arg11, num arg12, num arg13, num arg14, num arg15) {
    col0 = new vec4.zero();
    col1 = new vec4.zero();
    col2 = new vec4.zero();
    col3 = new vec4.zero();
    col0.x = arg0;
    col0.y = arg1;
    col0.z = arg2;
    col0.w = arg3;
    col1.x = arg4;
    col1.y = arg5;
    col1.z = arg6;
    col1.w = arg7;
    col2.x = arg8;
    col2.y = arg9;
    col2.z = arg10;
    col2.w = arg11;
    col3.x = arg12;
    col3.y = arg13;
    col3.z = arg14;
    col3.w = arg15;
  }
  /// Returns a printable string
  String toString() {
    String s = '';
    s = '$s[0] ${getRow(0)}\n';
    s = '$s[1] ${getRow(1)}\n';
    s = '$s[2] ${getRow(2)}\n';
    s = '$s[3] ${getRow(3)}\n';
    return s;
  }
  /// Returns the number of rows in the matrix.
  num get rows() => 4;
  /// Returns the number of columns in the matrix.
  num get cols() => 4;
  /// Returns the number of columns in the matrix.
  num get length() => 4;
  /// Gets the [column] of the matrix
  vec4 operator[](int column) {
    assert(column >= 0 && column < 4);
    switch (column) {
      case 0: return col0;
      case 1: return col1;
      case 2: return col2;
      case 3: return col3;
    }
    throw new IllegalArgumentException(column);
  }
  /// Assigns the [column] of the matrix [arg]
  void operator[]=(int column, vec4 arg) {
    assert(column >= 0 && column < 4);
    switch (column) {
      case 0: col0 = arg; break;
      case 1: col1 = arg; break;
      case 2: col2 = arg; break;
      case 3: col3 = arg; break;
    }
    throw new IllegalArgumentException(column);
  }
  /// Returns row 0
  vec4 get row0() => getRow(0);
  /// Returns row 1
  vec4 get row1() => getRow(1);
  /// Returns row 2
  vec4 get row2() => getRow(2);
  /// Returns row 3
  vec4 get row3() => getRow(3);
  /// Sets row 0 to [arg]
  set row0(vec4 arg) => setRow(0, arg);
  /// Sets row 1 to [arg]
  set row1(vec4 arg) => setRow(1, arg);
  /// Sets row 2 to [arg]
  set row2(vec4 arg) => setRow(2, arg);
  /// Sets row 3 to [arg]
  set row3(vec4 arg) => setRow(3, arg);
  /// Assigns the [column] of the matrix [arg]
  void setRow(int row, vec4 arg) {
    assert(row >= 0 && row < 4);
    col0[row] = arg.x;
    col1[row] = arg.y;
    col2[row] = arg.z;
    col3[row] = arg.w;
  }
  /// Gets the [row] of the matrix
  vec4 getRow(int row) {
    assert(row >= 0 && row < 4);
    vec4 r = new vec4();
    r.x = col0[row];
    r.y = col1[row];
    r.z = col2[row];
    r.w = col3[row];
    return r;
  }
  /// Assigns the [column] of the matrix [arg]
  void setColumn(int column, vec4 arg) {
    assert(column >= 0 && column < 4);
    this[column] = arg;
  }
  /// Gets the [column] of the matrix
  vec4 getColumn(int column) {
    assert(column >= 0 && column < 4);
    return new vec4(this[column]);
  }
  /// Returns a new vector or matrix by multiplying [this] with [arg].
  Dynamic operator*(Dynamic arg) {
    if (arg is num) {
      mat4 r = new mat4.zero();
      r.col0.x = col0.x * arg;
      r.col0.y = col0.y * arg;
      r.col0.z = col0.z * arg;
      r.col0.w = col0.w * arg;
      r.col1.x = col1.x * arg;
      r.col1.y = col1.y * arg;
      r.col1.z = col1.z * arg;
      r.col1.w = col1.w * arg;
      r.col2.x = col2.x * arg;
      r.col2.y = col2.y * arg;
      r.col2.z = col2.z * arg;
      r.col2.w = col2.w * arg;
      r.col3.x = col3.x * arg;
      r.col3.y = col3.y * arg;
      r.col3.z = col3.z * arg;
      r.col3.w = col3.w * arg;
      return r;
    }
    if (arg is vec4) {
      vec4 r = new vec4.zero();
      r.x =  (this.col0.x * arg.x) + (this.col1.x * arg.y) + (this.col2.x * arg.z) + (this.col3.x * arg.w);
      r.y =  (this.col0.y * arg.x) + (this.col1.y * arg.y) + (this.col2.y * arg.z) + (this.col3.y * arg.w);
      r.z =  (this.col0.z * arg.x) + (this.col1.z * arg.y) + (this.col2.z * arg.z) + (this.col3.z * arg.w);
      r.w =  (this.col0.w * arg.x) + (this.col1.w * arg.y) + (this.col2.w * arg.z) + (this.col3.w * arg.w);
      return r;
    }
    if (arg is vec3) {
      vec3 r = new vec3.zero();
      r.x =  (this.col0.x * arg.x) + (this.col1.x * arg.y) + (this.col2.x * arg.z) + col3.x;
      r.y =  (this.col0.y * arg.x) + (this.col1.y * arg.y) + (this.col2.y * arg.z) + col3.y;
      r.z =  (this.col0.z * arg.x) + (this.col1.z * arg.y) + (this.col2.z * arg.z) + col3.z;
      return r;
    }
    if (4 == arg.rows) {
      Dynamic r = null;
      if (arg.cols == 4) {
        r = new mat4.zero();
        r.col0.x =  (this.col0.x * arg.col0.x) + (this.col1.x * arg.col0.y) + (this.col2.x * arg.col0.z) + (this.col3.x * arg.col0.w);
        r.col1.x =  (this.col0.x * arg.col1.x) + (this.col1.x * arg.col1.y) + (this.col2.x * arg.col1.z) + (this.col3.x * arg.col1.w);
        r.col2.x =  (this.col0.x * arg.col2.x) + (this.col1.x * arg.col2.y) + (this.col2.x * arg.col2.z) + (this.col3.x * arg.col2.w);
        r.col3.x =  (this.col0.x * arg.col3.x) + (this.col1.x * arg.col3.y) + (this.col2.x * arg.col3.z) + (this.col3.x * arg.col3.w);
        r.col0.y =  (this.col0.y * arg.col0.x) + (this.col1.y * arg.col0.y) + (this.col2.y * arg.col0.z) + (this.col3.y * arg.col0.w);
        r.col1.y =  (this.col0.y * arg.col1.x) + (this.col1.y * arg.col1.y) + (this.col2.y * arg.col1.z) + (this.col3.y * arg.col1.w);
        r.col2.y =  (this.col0.y * arg.col2.x) + (this.col1.y * arg.col2.y) + (this.col2.y * arg.col2.z) + (this.col3.y * arg.col2.w);
        r.col3.y =  (this.col0.y * arg.col3.x) + (this.col1.y * arg.col3.y) + (this.col2.y * arg.col3.z) + (this.col3.y * arg.col3.w);
        r.col0.z =  (this.col0.z * arg.col0.x) + (this.col1.z * arg.col0.y) + (this.col2.z * arg.col0.z) + (this.col3.z * arg.col0.w);
        r.col1.z =  (this.col0.z * arg.col1.x) + (this.col1.z * arg.col1.y) + (this.col2.z * arg.col1.z) + (this.col3.z * arg.col1.w);
        r.col2.z =  (this.col0.z * arg.col2.x) + (this.col1.z * arg.col2.y) + (this.col2.z * arg.col2.z) + (this.col3.z * arg.col2.w);
        r.col3.z =  (this.col0.z * arg.col3.x) + (this.col1.z * arg.col3.y) + (this.col2.z * arg.col3.z) + (this.col3.z * arg.col3.w);
        r.col0.w =  (this.col0.w * arg.col0.x) + (this.col1.w * arg.col0.y) + (this.col2.w * arg.col0.z) + (this.col3.w * arg.col0.w);
        r.col1.w =  (this.col0.w * arg.col1.x) + (this.col1.w * arg.col1.y) + (this.col2.w * arg.col1.z) + (this.col3.w * arg.col1.w);
        r.col2.w =  (this.col0.w * arg.col2.x) + (this.col1.w * arg.col2.y) + (this.col2.w * arg.col2.z) + (this.col3.w * arg.col2.w);
        r.col3.w =  (this.col0.w * arg.col3.x) + (this.col1.w * arg.col3.y) + (this.col2.w * arg.col3.z) + (this.col3.w * arg.col3.w);
        return r;
      }
      return r;
    }
    throw new IllegalArgumentException(arg);
  }
  /// Returns new matrix after component wise [this] + [arg]
  mat4 operator+(mat4 arg) {
    mat4 r = new mat4();
    r.col0.x = col0.x + arg.col0.x;
    r.col0.y = col0.y + arg.col0.y;
    r.col0.z = col0.z + arg.col0.z;
    r.col0.w = col0.w + arg.col0.w;
    r.col1.x = col1.x + arg.col1.x;
    r.col1.y = col1.y + arg.col1.y;
    r.col1.z = col1.z + arg.col1.z;
    r.col1.w = col1.w + arg.col1.w;
    r.col2.x = col2.x + arg.col2.x;
    r.col2.y = col2.y + arg.col2.y;
    r.col2.z = col2.z + arg.col2.z;
    r.col2.w = col2.w + arg.col2.w;
    r.col3.x = col3.x + arg.col3.x;
    r.col3.y = col3.y + arg.col3.y;
    r.col3.z = col3.z + arg.col3.z;
    r.col3.w = col3.w + arg.col3.w;
    return r;
  }
  /// Returns new matrix after component wise [this] - [arg]
  mat4 operator-(mat4 arg) {
    mat4 r = new mat4();
    r.col0.x = col0.x - arg.col0.x;
    r.col0.y = col0.y - arg.col0.y;
    r.col0.z = col0.z - arg.col0.z;
    r.col0.w = col0.w - arg.col0.w;
    r.col1.x = col1.x - arg.col1.x;
    r.col1.y = col1.y - arg.col1.y;
    r.col1.z = col1.z - arg.col1.z;
    r.col1.w = col1.w - arg.col1.w;
    r.col2.x = col2.x - arg.col2.x;
    r.col2.y = col2.y - arg.col2.y;
    r.col2.z = col2.z - arg.col2.z;
    r.col2.w = col2.w - arg.col2.w;
    r.col3.x = col3.x - arg.col3.x;
    r.col3.y = col3.y - arg.col3.y;
    r.col3.z = col3.z - arg.col3.z;
    r.col3.w = col3.w - arg.col3.w;
    return r;
  }
  /// Translate this matrix by a [vec3], [vec4], or x,y,z
  mat4 translate(Dynamic x, [num y = 0.0, num z = 0.0]) {
    num tx;
    num ty;
    num tz;
    num tw = x is vec4 ? x.w : 1.0;
    if (x is vec3 || x is vec4) {
      tx = x.x;
      ty = x.y;
      tz = x.z;
    } else {
      tx = x;
      ty = y;
      tz = z;
    }
    var t1 = col0.x * tx + col1.x * ty + col2.x * tz + col3.x * tw;
    var t2 = col0.y * tx + col1.y * ty + col2.y * tz + col3.y * tw;
    var t3 = col0.z * tx + col1.z * ty + col2.z * tz + col3.z * tw;
    var t4 = col0.w * tx + col1.w * ty + col2.w * tz + col3.w * tw;
    col3.x = t1;
    col3.y = t2;
    col3.z = t3;
    col3.w = t4;
    return this;
  }
  /// Rotate this [angle] radians around [axis]
  mat4 rotate(vec3 axis, num angle) {
    var len = axis.length;
    var x = axis.x/len;
    var y = axis.y/len;
    var z = axis.y/len;
    var c = cos(angle);
    var s = sin(angle);
    var C = 1.0 - c;
    var m11 = x * x * C + c;
    var m12 = x * y * C - z * s;
    var m13 = x * z * C + y * s;
    var m21 = y * x * C + z * s;
    var m22 = y * y * C + c;
    var m23 = y * z * C - x * s;
    var m31 = z * x * C - y * s;
    var m32 = z * y * C + x * s;
    var m33 = z * z * C + c;
    var t1 = col0.x * m11 + col1.x * m21 + col2.x * m31 + col3.x * 0.0;
    var t2 = col0.y * m11 + col1.y * m21 + col2.y * m31 + col3.y * 0.0;
    var t3 = col0.z * m11 + col1.z * m21 + col2.z * m31 + col3.z * 0.0;
    var t4 = col0.w * m11 + col1.w * m21 + col2.w * m31 + col3.w * 0.0;
    var t5 = col0.x * m12 + col1.x * m22 + col2.x * m32 + col3.x * 0.0;
    var t6 = col0.y * m12 + col1.y * m22 + col2.y * m32 + col3.y * 0.0;
    var t7 = col0.z * m12 + col1.z * m22 + col2.z * m32 + col3.z * 0.0;
    var t8 = col0.w * m12 + col1.w * m22 + col2.w * m32 + col3.w * 0.0;
    var t9 = col0.x * m13 + col1.x * m23 + col2.x * m33 + col3.x * 0.0;
    var t10 = col0.y * m13 + col1.y * m23 + col2.y * m33 + col3.y * 0.0;
    var t11 = col0.z * m13 + col1.z * m23 + col2.z * m33 + col3.z * 0.0;
    var t12 = col0.w * m13 + col1.w * m23 + col2.w * m33 + col3.w * 0.0;
    col0.x = t1;
    col0.y = t2;
    col0.z = t3;
    col0.w = t4;
    col1.x = t5;
    col1.y = t6;
    col1.z = t7;
    col1.w = t8;
    col2.x = t9;
    col2.y = t10;
    col2.z = t11;
    col2.w = t12;
    return this;
  }
  /// Rotate this [angle] radians around X
  mat4 rotateX(num angle) {
    num cosAngle = cos(angle);
    num sinAngle = sin(angle);
    var t1 = col0.x * 0.0 + col1.x * cosAngle + col2.x * sinAngle + col3.x * 0.0;
    var t2 = col0.y * 0.0 + col1.y * cosAngle + col2.y * sinAngle + col3.y * 0.0;
    var t3 = col0.z * 0.0 + col1.z * cosAngle + col2.z * sinAngle + col3.z * 0.0;
    var t4 = col0.w * 0.0 + col1.w * cosAngle + col2.w * sinAngle + col3.w * 0.0;
    var t5 = col0.x * 0.0 + col1.x * -sinAngle + col2.x * cosAngle + col3.x * 0.0;
    var t6 = col0.y * 0.0 + col1.y * -sinAngle + col2.y * cosAngle + col3.y * 0.0;
    var t7 = col0.z * 0.0 + col1.z * -sinAngle + col2.z * cosAngle + col3.z * 0.0;
    var t8 = col0.w * 0.0 + col1.w * -sinAngle + col2.w * cosAngle + col3.w * 0.0;
    col1.x = t1;
    col1.y = t2;
    col1.z = t3;
    col1.w = t4;
    col2.x = t5;
    col2.y = t6;
    col2.z = t7;
    col2.w = t8;
    return this;
  }
  /// Rotate this matrix [angle] radians around Y
  mat4 rotateY(num angle) {
    num cosAngle = cos(angle);
    num sinAngle = sin(angle);
    var t1 = col0.x * cosAngle + col1.x * 0.0 + col2.x * sinAngle + col3.x * 0.0;
    var t2 = col0.y * cosAngle + col1.y * 0.0 + col2.y * sinAngle + col3.y * 0.0;
    var t3 = col0.z * cosAngle + col1.z * 0.0 + col2.z * sinAngle + col3.z * 0.0;
    var t4 = col0.w * cosAngle + col1.w * 0.0 + col2.w * sinAngle + col3.w * 0.0;
    var t5 = col0.x * -sinAngle + col1.x * 0.0 + col2.x * cosAngle + col3.x * 0.0;
    var t6 = col0.y * -sinAngle + col1.y * 0.0 + col2.y * cosAngle + col3.y * 0.0;
    var t7 = col0.z * -sinAngle + col1.z * 0.0 + col2.z * cosAngle + col3.z * 0.0;
    var t8 = col0.w * -sinAngle + col1.w * 0.0 + col2.w * cosAngle + col3.w * 0.0;
    col0.x = t1;
    col0.y = t2;
    col0.z = t3;
    col0.w = t4;
    col2.x = t5;
    col2.y = t6;
    col2.z = t7;
    col2.w = t8;
    return this;
  }
  /// Rotate this matrix [angle] radians around Z
  mat4 rotateZ(num angle) {
    num cosAngle = cos(angle);
    num sinAngle = sin(angle);
    var t1 = col0.x * cosAngle + col1.x * sinAngle + col2.x * 0.0 + col3.x * 0.0;
    var t2 = col0.y * cosAngle + col1.y * sinAngle + col2.y * 0.0 + col3.y * 0.0;
    var t3 = col0.z * cosAngle + col1.z * sinAngle + col2.z * 0.0 + col3.z * 0.0;
    var t4 = col0.w * cosAngle + col1.w * sinAngle + col2.w * 0.0 + col3.w * 0.0;
    var t5 = col0.x * -sinAngle + col1.x * cosAngle + col2.x * 0.0 + col3.x * 0.0;
    var t6 = col0.y * -sinAngle + col1.y * cosAngle + col2.y * 0.0 + col3.y * 0.0;
    var t7 = col0.z * -sinAngle + col1.z * cosAngle + col2.z * 0.0 + col3.z * 0.0;
    var t8 = col0.w * -sinAngle + col1.w * cosAngle + col2.w * 0.0 + col3.w * 0.0;
    col0.x = t1;
    col0.y = t2;
    col0.z = t3;
    col0.w = t4;
    col1.x = t5;
    col1.y = t6;
    col1.z = t7;
    col1.w = t8;
    return this;
  }
  /// Scale this matrix by a [vec3], [vec4], or x,y,z
  mat4 scale(Dynamic x, [num y = null, num z = null]) {
    num sx;
    num sy;
    num sz;
    num sw = x is vec4 ? x.w : 1.0;
    if (x is vec3 || x is vec4) {
      sx = x.x;
      sy = x.y;
      sz = x.z;
    } else {
      sx = x;
      sy = y == null ? x : y;
      sz = z == null ? x : z;
    }
    col0.x *= sx;
    col1.x *= sx;
    col2.x *= sx;
    col3.x *= sx;
    col0.y *= sy;
    col1.y *= sy;
    col2.y *= sy;
    col3.y *= sy;
    col0.z *= sz;
    col1.z *= sz;
    col2.z *= sz;
    col3.z *= sz;
    col0.w *= sw;
    col1.w *= sw;
    col2.w *= sw;
    col3.w *= sw;
    return this;
  }
  /// Returns new matrix -this
  mat4 operator -() {
    mat4 r = new mat4();
    r[0] = -this[0];
    r[1] = -this[1];
    r[2] = -this[2];
    r[3] = -this[3];
    return r;
  }
  /// Zeros [this].
  mat4 setZero() {
    col0.x = 0.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col0.w = 0.0;
    col1.x = 0.0;
    col1.y = 0.0;
    col1.z = 0.0;
    col1.w = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 0.0;
    col2.w = 0.0;
    col3.x = 0.0;
    col3.y = 0.0;
    col3.z = 0.0;
    col3.w = 0.0;
    return this;
  }
  /// Makes [this] into the identity matrix.
  mat4 setIdentity() {
    col0.x = 1.0;
    col0.y = 0.0;
    col0.z = 0.0;
    col0.w = 0.0;
    col1.x = 0.0;
    col1.y = 1.0;
    col1.z = 0.0;
    col1.w = 0.0;
    col2.x = 0.0;
    col2.y = 0.0;
    col2.z = 1.0;
    col2.w = 0.0;
    col3.x = 0.0;
    col3.y = 0.0;
    col3.z = 0.0;
    col3.w = 1.0;
    return this;
  }
  /// Returns the tranpose of this.
  mat4 transposed() {
    mat4 r = new mat4();
    r.col0.x = col0.x;
    r.col0.y = col1.x;
    r.col0.z = col2.x;
    r.col0.w = col3.x;
    r.col1.x = col0.y;
    r.col1.y = col1.y;
    r.col1.z = col2.y;
    r.col1.w = col3.y;
    r.col2.x = col0.z;
    r.col2.y = col1.z;
    r.col2.z = col2.z;
    r.col2.w = col3.z;
    r.col3.x = col0.w;
    r.col3.y = col1.w;
    r.col3.z = col2.w;
    r.col3.w = col3.w;
    return r;
  }
  /// Returns the component wise absolute value of this.
  mat4 absolute() {
    mat4 r = new mat4();
    r.col0.x = col0.x.abs();
    r.col0.y = col0.y.abs();
    r.col0.z = col0.z.abs();
    r.col0.w = col0.w.abs();
    r.col1.x = col1.x.abs();
    r.col1.y = col1.y.abs();
    r.col1.z = col1.z.abs();
    r.col1.w = col1.w.abs();
    r.col2.x = col2.x.abs();
    r.col2.y = col2.y.abs();
    r.col2.z = col2.z.abs();
    r.col2.w = col2.w.abs();
    r.col3.x = col3.x.abs();
    r.col3.y = col3.y.abs();
    r.col3.z = col3.z.abs();
    r.col3.w = col3.w.abs();
    return r;
  }
  /// Returns the determinant of this matrix.
  num determinant() {
    num det2_01_01 = col0.x * col1.y - col0.y * col1.x;
    num det2_01_02 = col0.x * col1.z - col0.z * col1.x;
    num det2_01_03 = col0.x * col1.w - col0.w * col1.x;
    num det2_01_12 = col0.y * col1.z - col0.z * col1.y;
    num det2_01_13 = col0.y * col1.w - col0.w * col1.y;
    num det2_01_23 = col0.z * col1.w - col0.w * col1.z;
    num det3_201_012 = col2.x * det2_01_12 - col2.y * det2_01_02 + col2.z * det2_01_01;
    num det3_201_013 = col2.x * det2_01_13 - col2.y * det2_01_03 + col2.w * det2_01_01;
    num det3_201_023 = col2.x * det2_01_23 - col2.z * det2_01_03 + col2.w * det2_01_02;
    num det3_201_123 = col2.y * det2_01_23 - col2.z * det2_01_13 + col2.w * det2_01_12;
    return ( - det3_201_123 * col3.x + det3_201_023 * col3.y - det3_201_013 * col3.z + det3_201_012 * col3.w);
  }
  /// Returns the trace of the matrix. The trace of a matrix is the sum of the diagonal entries
  num trace() {
    num t = 0.0;
    t += col0.x;
    t += col1.y;
    t += col2.z;
    t += col3.w;
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
      row_norm += this[0][3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[1][0].abs();
      row_norm += this[1][1].abs();
      row_norm += this[1][2].abs();
      row_norm += this[1][3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[2][0].abs();
      row_norm += this[2][1].abs();
      row_norm += this[2][2].abs();
      row_norm += this[2][3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    {
      num row_norm = 0.0;
      row_norm += this[3][0].abs();
      row_norm += this[3][1].abs();
      row_norm += this[3][2].abs();
      row_norm += this[3][3].abs();
      norm = row_norm > norm ? row_norm : norm;
    }
    return norm;
  }
  /// Returns relative error between [this] and [correct]
  num relativeError(mat4 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  /// Returns absolute error between [this] and [correct]
  num absoluteError(mat4 correct) {
    num this_norm = infinityNorm();
    num correct_norm = correct.infinityNorm();
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  /// Returns the translation vector from this homogeneous transformation matrix.
  vec3 getTranslation() {
    return new vec3(col3.x, col3.y, col3.z);
  }
  /// Sets the translation vector in this homogeneous transformation matrix.
  void setTranslation(vec3 T) {
    col3.xyz = T;
  }
  /// Returns the rotation matrix from this homogeneous transformation matrix.
  mat3 getRotation() {
    mat3 r = new mat3();
    r.col0 = new vec3(this.col0.x,this.col0.y,this.col0.z);
    r.col1 = new vec3(this.col1.x,this.col1.y,this.col1.z);
    r.col2 = new vec3(this.col2.x,this.col2.y,this.col2.z);
    return r;
  }
  /// Sets the rotation matrix in this homogeneous transformation matrix.
  void setRotation(mat3 rotation) {
    this.col0.xyz = rotation.col0;
    this.col1.xyz = rotation.col1;
    this.col2.xyz = rotation.col2;
  }
  /// Transposes just the upper 3x3 rotation matrix.
  mat4 transposeRotation() {
    num temp;
    temp = this.col0.y;
    this.col0.y = this.col1.x;
    this.col1.x = temp;
    temp = this.col0.z;
    this.col0.z = this.col2.x;
    this.col2.x = temp;
    temp = this.col1.x;
    this.col1.x = this.col0.y;
    this.col0.y = temp;
    temp = this.col1.z;
    this.col1.z = this.col2.y;
    this.col2.y = temp;
    temp = this.col2.x;
    this.col2.x = this.col0.z;
    this.col0.z = temp;
    temp = this.col2.y;
    this.col2.y = this.col1.z;
    this.col1.z = temp;
    return this;
  }
  num invert() {
    num det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    num invDet = 1.0 / det;
    scaleAdjoint(invDet);
    return det;
  }
  num invertRotation() {
    num det = determinant();
    if (det == 0.0) {
      return 0.0;
    }
    num invDet = 1.0 / det;
    vec4 i = new vec4.zero();
    vec4 j = new vec4.zero();
    vec4 k = new vec4.zero();
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
  /// Sets the upper 3x3 to a rotation of [radians] around X
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
    col0.w = 0.0;
    col1.w = 0.0;
    col2.w = 0.0;
  }
  /// Sets the upper 3x3 to a rotation of [radians] around Y
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
    col0.w = 0.0;
    col1.w = 0.0;
    col2.w = 0.0;
  }
  /// Sets the upper 3x3 to a rotation of [radians] around Z
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
    col0.w = 0.0;
    col1.w = 0.0;
    col2.w = 0.0;
  }
  /// Converts into Adjugate matrix and scales by [scale]
  mat4 scaleAdjoint(num scale_) {
    // Adapted from code by Richard Carling.
    num a1 = col0.x;
    num b1 = col1.x;
    num c1 = col2.x;
    num d1 = col3.x;
    num a2 = col0.y;
    num b2 = col1.y;
    num c2 = col2.y;
    num d2 = col3.y;
    num a3 = col0.z;
    num b3 = col1.z;
    num c3 = col2.z;
    num d3 = col3.z;
    num a4 = col0.w;
    num b4 = col1.w;
    num c4 = col2.w;
    num d4 = col3.w;
    col0.x  =   (b2 * (c3 * d4 - c4 * d3) - c2 * (b3 * d4 - b4 * d3) + d2 * (b3 * c4 - b4 * c3)) * scale_;
    col0.y  = - (a2 * (c3 * d4 - c4 * d3) - c2 * (a3 * d4 - a4 * d3) + d2 * (a3 * c4 - a4 * c3)) * scale_;
    col0.z  =   (a2 * (b3 * d4 - b4 * d3) - b2 * (a3 * d4 - a4 * d3) + d2 * (a3 * b4 - a4 * b3)) * scale_;
    col0.w  = - (a2 * (b3 * c4 - b4 * c3) - b2 * (a3 * c4 - a4 * c3) + c2 * (a3 * b4 - a4 * b3)) * scale_;
    col1.x  = - (b1 * (c3 * d4 - c4 * d3) - c1 * (b3 * d4 - b4 * d3) + d1 * (b3 * c4 - b4 * c3)) * scale_;
    col1.y  =   (a1 * (c3 * d4 - c4 * d3) - c1 * (a3 * d4 - a4 * d3) + d1 * (a3 * c4 - a4 * c3)) * scale_;
    col1.z  = - (a1 * (b3 * d4 - b4 * d3) - b1 * (a3 * d4 - a4 * d3) + d1 * (a3 * b4 - a4 * b3)) * scale_;
    col1.w  =   (a1 * (b3 * c4 - b4 * c3) - b1 * (a3 * c4 - a4 * c3) + c1 * (a3 * b4 - a4 * b3)) * scale_;
    col2.x  =   (b1 * (c2 * d4 - c4 * d2) - c1 * (b2 * d4 - b4 * d2) + d1 * (b2 * c4 - b4 * c2)) * scale_;
    col2.y  = - (a1 * (c2 * d4 - c4 * d2) - c1 * (a2 * d4 - a4 * d2) + d1 * (a2 * c4 - a4 * c2)) * scale_;
    col2.z  =   (a1 * (b2 * d4 - b4 * d2) - b1 * (a2 * d4 - a4 * d2) + d1 * (a2 * b4 - a4 * b2)) * scale_;
    col2.w  = - (a1 * (b2 * c4 - b4 * c2) - b1 * (a2 * c4 - a4 * c2) + c1 * (a2 * b4 - a4 * b2)) * scale_;
    col3.x  = - (b1 * (c2 * d3 - c3 * d2) - c1 * (b2 * d3 - b3 * d2) + d1 * (b2 * c3 - b3 * c2)) * scale_;
    col3.y  =   (a1 * (c2 * d3 - c3 * d2) - c1 * (a2 * d3 - a3 * d2) + d1 * (a2 * c3 - a3 * c2)) * scale_;
    col3.z  = - (a1 * (b2 * d3 - b3 * d2) - b1 * (a2 * d3 - a3 * d2) + d1 * (a2 * b3 - a3 * b2)) * scale_;
    col3.w  =   (a1 * (b2 * c3 - b3 * c2) - b1 * (a2 * c3 - a3 * c2) + c1 * (a2 * b3 - a3 * b2)) * scale_;
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
  mat4 newCopy() {
    return new mat4.copy(this);
  }
  mat4 copyInto(mat4 arg) {
    arg.col0.x = col0.x;
    arg.col0.y = col0.y;
    arg.col0.z = col0.z;
    arg.col0.w = col0.w;
    arg.col1.x = col1.x;
    arg.col1.y = col1.y;
    arg.col1.z = col1.z;
    arg.col1.w = col1.w;
    arg.col2.x = col2.x;
    arg.col2.y = col2.y;
    arg.col2.z = col2.z;
    arg.col2.w = col2.w;
    arg.col3.x = col3.x;
    arg.col3.y = col3.y;
    arg.col3.z = col3.z;
    arg.col3.w = col3.w;
    return arg;
  }
  mat4 copyFrom(mat4 arg) {
    col0.x = arg.col0.x;
    col0.y = arg.col0.y;
    col0.z = arg.col0.z;
    col0.w = arg.col0.w;
    col1.x = arg.col1.x;
    col1.y = arg.col1.y;
    col1.z = arg.col1.z;
    col1.w = arg.col1.w;
    col2.x = arg.col2.x;
    col2.y = arg.col2.y;
    col2.z = arg.col2.z;
    col2.w = arg.col2.w;
    col3.x = arg.col3.x;
    col3.y = arg.col3.y;
    col3.z = arg.col3.z;
    col3.w = arg.col3.w;
    return this;
  }
  mat4 add(mat4 o) {
    col0.x = col0.x + o.col0.x;
    col0.y = col0.y + o.col0.y;
    col0.z = col0.z + o.col0.z;
    col0.w = col0.w + o.col0.w;
    col1.x = col1.x + o.col1.x;
    col1.y = col1.y + o.col1.y;
    col1.z = col1.z + o.col1.z;
    col1.w = col1.w + o.col1.w;
    col2.x = col2.x + o.col2.x;
    col2.y = col2.y + o.col2.y;
    col2.z = col2.z + o.col2.z;
    col2.w = col2.w + o.col2.w;
    col3.x = col3.x + o.col3.x;
    col3.y = col3.y + o.col3.y;
    col3.z = col3.z + o.col3.z;
    col3.w = col3.w + o.col3.w;
    return this;
  }
  mat4 sub(mat4 o) {
    col0.x = col0.x - o.col0.x;
    col0.y = col0.y - o.col0.y;
    col0.z = col0.z - o.col0.z;
    col0.w = col0.w - o.col0.w;
    col1.x = col1.x - o.col1.x;
    col1.y = col1.y - o.col1.y;
    col1.z = col1.z - o.col1.z;
    col1.w = col1.w - o.col1.w;
    col2.x = col2.x - o.col2.x;
    col2.y = col2.y - o.col2.y;
    col2.z = col2.z - o.col2.z;
    col2.w = col2.w - o.col2.w;
    col3.x = col3.x - o.col3.x;
    col3.y = col3.y - o.col3.y;
    col3.z = col3.z - o.col3.z;
    col3.w = col3.w - o.col3.w;
    return this;
  }
  mat4 negate() {
    col0.x = -col0.x;
    col0.y = -col0.y;
    col0.z = -col0.z;
    col0.w = -col0.w;
    col1.x = -col1.x;
    col1.y = -col1.y;
    col1.z = -col1.z;
    col1.w = -col1.w;
    col2.x = -col2.x;
    col2.y = -col2.y;
    col2.z = -col2.z;
    col2.w = -col2.w;
    col3.x = -col3.x;
    col3.y = -col3.y;
    col3.z = -col3.z;
    col3.w = -col3.w;
    return this;
  }
  mat4 multiply(mat4 arg) {
    final num m00 = col0.x;
    final num m01 = col1.x;
    final num m02 = col2.x;
    final num m03 = col3.x;
    final num m10 = col0.y;
    final num m11 = col1.y;
    final num m12 = col2.y;
    final num m13 = col3.y;
    final num m20 = col0.z;
    final num m21 = col1.z;
    final num m22 = col2.z;
    final num m23 = col3.z;
    final num m30 = col0.w;
    final num m31 = col1.w;
    final num m32 = col2.w;
    final num m33 = col3.w;
    final num n00 = arg.col0.x;
    final num n01 = arg.col1.x;
    final num n02 = arg.col2.x;
    final num n03 = arg.col3.x;
    final num n10 = arg.col0.y;
    final num n11 = arg.col1.y;
    final num n12 = arg.col2.y;
    final num n13 = arg.col3.y;
    final num n20 = arg.col0.z;
    final num n21 = arg.col1.z;
    final num n22 = arg.col2.z;
    final num n23 = arg.col3.z;
    final num n30 = arg.col0.w;
    final num n31 = arg.col1.w;
    final num n32 = arg.col2.w;
    final num n33 = arg.col3.w;
    col0.x =  (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
    col1.x =  (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
    col2.x =  (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
    col3.x =  (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
    col0.y =  (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
    col1.y =  (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
    col2.y =  (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
    col3.y =  (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
    col0.z =  (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
    col1.z =  (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
    col2.z =  (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
    col3.z =  (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
    col0.w =  (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
    col1.w =  (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
    col2.w =  (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
    col3.w =  (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);
    return this;
  }
  mat4 transposeMultiply(mat4 arg) {
    num m00 = col0.x;
    num m01 = col0.y;
    num m02 = col0.z;
    num m03 = col0.w;
    num m10 = col1.x;
    num m11 = col1.y;
    num m12 = col1.z;
    num m13 = col1.w;
    num m20 = col2.x;
    num m21 = col2.y;
    num m22 = col2.z;
    num m23 = col2.w;
    num m30 = col3.x;
    num m31 = col3.y;
    num m32 = col3.z;
    num m33 = col3.w;
    col0.x =  (m00 * arg.col0.x) + (m01 * arg.col0.y) + (m02 * arg.col0.z) + (m03 * arg.col0.w);
    col1.x =  (m00 * arg.col1.x) + (m01 * arg.col1.y) + (m02 * arg.col1.z) + (m03 * arg.col1.w);
    col2.x =  (m00 * arg.col2.x) + (m01 * arg.col2.y) + (m02 * arg.col2.z) + (m03 * arg.col2.w);
    col3.x =  (m00 * arg.col3.x) + (m01 * arg.col3.y) + (m02 * arg.col3.z) + (m03 * arg.col3.w);
    col0.y =  (m10 * arg.col0.x) + (m11 * arg.col0.y) + (m12 * arg.col0.z) + (m13 * arg.col0.w);
    col1.y =  (m10 * arg.col1.x) + (m11 * arg.col1.y) + (m12 * arg.col1.z) + (m13 * arg.col1.w);
    col2.y =  (m10 * arg.col2.x) + (m11 * arg.col2.y) + (m12 * arg.col2.z) + (m13 * arg.col2.w);
    col3.y =  (m10 * arg.col3.x) + (m11 * arg.col3.y) + (m12 * arg.col3.z) + (m13 * arg.col3.w);
    col0.z =  (m20 * arg.col0.x) + (m21 * arg.col0.y) + (m22 * arg.col0.z) + (m23 * arg.col0.w);
    col1.z =  (m20 * arg.col1.x) + (m21 * arg.col1.y) + (m22 * arg.col1.z) + (m23 * arg.col1.w);
    col2.z =  (m20 * arg.col2.x) + (m21 * arg.col2.y) + (m22 * arg.col2.z) + (m23 * arg.col2.w);
    col3.z =  (m20 * arg.col3.x) + (m21 * arg.col3.y) + (m22 * arg.col3.z) + (m23 * arg.col3.w);
    col0.w =  (m30 * arg.col0.x) + (m31 * arg.col0.y) + (m32 * arg.col0.z) + (m33 * arg.col0.w);
    col1.w =  (m30 * arg.col1.x) + (m31 * arg.col1.y) + (m32 * arg.col1.z) + (m33 * arg.col1.w);
    col2.w =  (m30 * arg.col2.x) + (m31 * arg.col2.y) + (m32 * arg.col2.z) + (m33 * arg.col2.w);
    col3.w =  (m30 * arg.col3.x) + (m31 * arg.col3.y) + (m32 * arg.col3.z) + (m33 * arg.col3.w);
    return this;
  }
  mat4 multiplyTranspose(mat4 arg) {
    num m00 = col0.x;
    num m01 = col1.x;
    num m02 = col2.x;
    num m03 = col3.x;
    num m10 = col0.y;
    num m11 = col1.y;
    num m12 = col2.y;
    num m13 = col3.y;
    num m20 = col0.z;
    num m21 = col1.z;
    num m22 = col2.z;
    num m23 = col3.z;
    num m30 = col0.w;
    num m31 = col1.w;
    num m32 = col2.w;
    num m33 = col3.w;
    col0.x =  (m00 * arg.col0.x) + (m01 * arg.col1.x) + (m02 * arg.col2.x) + (m03 * arg.col3.x);
    col1.x =  (m00 * arg.col0.y) + (m01 * arg.col1.y) + (m02 * arg.col2.y) + (m03 * arg.col3.y);
    col2.x =  (m00 * arg.col0.z) + (m01 * arg.col1.z) + (m02 * arg.col2.z) + (m03 * arg.col3.z);
    col3.x =  (m00 * arg.col0.w) + (m01 * arg.col1.w) + (m02 * arg.col2.w) + (m03 * arg.col3.w);
    col0.y =  (m10 * arg.col0.x) + (m11 * arg.col1.x) + (m12 * arg.col2.x) + (m13 * arg.col3.x);
    col1.y =  (m10 * arg.col0.y) + (m11 * arg.col1.y) + (m12 * arg.col2.y) + (m13 * arg.col3.y);
    col2.y =  (m10 * arg.col0.z) + (m11 * arg.col1.z) + (m12 * arg.col2.z) + (m13 * arg.col3.z);
    col3.y =  (m10 * arg.col0.w) + (m11 * arg.col1.w) + (m12 * arg.col2.w) + (m13 * arg.col3.w);
    col0.z =  (m20 * arg.col0.x) + (m21 * arg.col1.x) + (m22 * arg.col2.x) + (m23 * arg.col3.x);
    col1.z =  (m20 * arg.col0.y) + (m21 * arg.col1.y) + (m22 * arg.col2.y) + (m23 * arg.col3.y);
    col2.z =  (m20 * arg.col0.z) + (m21 * arg.col1.z) + (m22 * arg.col2.z) + (m23 * arg.col3.z);
    col3.z =  (m20 * arg.col0.w) + (m21 * arg.col1.w) + (m22 * arg.col2.w) + (m23 * arg.col3.w);
    col0.w =  (m30 * arg.col0.x) + (m31 * arg.col1.x) + (m32 * arg.col2.x) + (m33 * arg.col3.x);
    col1.w =  (m30 * arg.col0.y) + (m31 * arg.col1.y) + (m32 * arg.col2.y) + (m33 * arg.col3.y);
    col2.w =  (m30 * arg.col0.z) + (m31 * arg.col1.z) + (m32 * arg.col2.z) + (m33 * arg.col3.z);
    col3.w =  (m30 * arg.col0.w) + (m31 * arg.col1.w) + (m32 * arg.col2.w) + (m33 * arg.col3.w);
    return this;
  }
  vec3 rotate3(vec3 arg) {
    num x_ =  (this.col0.x * arg.x) + (this.col1.x * arg.y) + (this.col2.x * arg.z);
    num y_ =  (this.col0.y * arg.x) + (this.col1.y * arg.y) + (this.col2.y * arg.z);
    num z_ =  (this.col0.z * arg.x) + (this.col1.z * arg.y) + (this.col2.z * arg.z);
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    return arg;
  }
  vec3 rotated3(vec3 arg, [vec3 out=null]) {
    if (out == null) {
      out = new vec3.copy(arg);
    } else {
      out.copyFrom(arg);
    }
    return rotate3(out);
  }
  vec3 transform3(vec3 arg) {
    num x_ =  (this.col0.x * arg.x) + (this.col1.x * arg.y) + (this.col2.x * arg.z) + col3.x;
    num y_ =  (this.col0.y * arg.x) + (this.col1.y * arg.y) + (this.col2.y * arg.z) + col3.y;
    num z_ =  (this.col0.z * arg.x) + (this.col1.z * arg.y) + (this.col2.z * arg.z) + col3.z;
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    return arg;
  }
  vec3 transformed3(vec3 arg, [vec3 out=null]) {
    if (out == null) {
      out = new vec3.copy(arg);
    } else {
      out.copyFrom(arg);
    }
    return transform3(out);
  }
  vec4 transform(vec4 arg) {
    num x_ =  (this.col0.x * arg.x) + (this.col1.x * arg.y) + (this.col2.x * arg.z);
    num y_ =  (this.col0.y * arg.x) + (this.col1.y * arg.y) + (this.col2.y * arg.z);
    num z_ =  (this.col0.z * arg.x) + (this.col1.z * arg.y) + (this.col2.z * arg.z);
    num w_ =  (this.col0.w * arg.x) + (this.col1.w * arg.y) + (this.col2.w * arg.z);
    arg.x = x_;
    arg.y = y_;
    arg.z = z_;
    arg.w = w_;
    return arg;
  }
  vec4 transformed(vec4 arg, [vec4 out=null]) {
    if (out == null) {
      out = new vec4.copy(arg);
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
    array[i] = col0.w;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col1.z;
    i++;
    array[i] = col1.w;
    i++;
    array[i] = col2.x;
    i++;
    array[i] = col2.y;
    i++;
    array[i] = col2.z;
    i++;
    array[i] = col2.w;
    i++;
    array[i] = col3.x;
    i++;
    array[i] = col3.y;
    i++;
    array[i] = col3.z;
    i++;
    array[i] = col3.w;
    i++;
  }
  /// Returns a copy of [this] as a [Float32Array].
  Float32Array copyAsArray() {
    Float32Array array = new Float32Array(16);
    int i = 0;
    array[i] = col0.x;
    i++;
    array[i] = col0.y;
    i++;
    array[i] = col0.z;
    i++;
    array[i] = col0.w;
    i++;
    array[i] = col1.x;
    i++;
    array[i] = col1.y;
    i++;
    array[i] = col1.z;
    i++;
    array[i] = col1.w;
    i++;
    array[i] = col2.x;
    i++;
    array[i] = col2.y;
    i++;
    array[i] = col2.z;
    i++;
    array[i] = col2.w;
    i++;
    array[i] = col3.x;
    i++;
    array[i] = col3.y;
    i++;
    array[i] = col3.z;
    i++;
    array[i] = col3.w;
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
    col0.w = array[i];
    i++;
    col1.x = array[i];
    i++;
    col1.y = array[i];
    i++;
    col1.z = array[i];
    i++;
    col1.w = array[i];
    i++;
    col2.x = array[i];
    i++;
    col2.y = array[i];
    i++;
    col2.z = array[i];
    i++;
    col2.w = array[i];
    i++;
    col3.x = array[i];
    i++;
    col3.y = array[i];
    i++;
    col3.z = array[i];
    i++;
    col3.w = array[i];
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
