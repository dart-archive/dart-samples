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
class vec3 {
  num x;
  num y;
  num z;
  /// Constructs a new [vec3]. Follows GLSL constructor syntax so many combinations are possible
  vec3([Dynamic x_, Dynamic y_, Dynamic z_]) {
    x = y = z = 0.0;
    if (x_ is vec2 && y_ is num) {
      this.xy = x_.xy;
      this.z = y_;
    }
    if (x_ is num && y_ is vec2) {
      this.x = x_;
      this.yz = y_.xy;
    }
    if (x_ is vec2 && y_ == null) {
      this.xy = x_.xy;
      this.z = 0;
    }
    if (x_ is vec3) {
      xyz = x_.xyz;
      return;
    }
    if (x_ is num && y_ is num && z_ is num) {
      x = x_;
      y = y_;
      z = z_;
      return;
    }
    if (x_ is num) {
      x = y = z = x_;
      return;
    }
  }
  /// Constructs a new [vec3] filled with 0.
  vec3.zero() {
    x = 0.0;
    y = 0.0;
    z = 0.0;
  }
  /// Constructs a new [vec3] that is a copy of [other].
  vec3.copy(vec3 other) {
    x = other.x;
    y = other.y;
    z = other.z;
  }
  /// Constructs a new [vec3] that is initialized with passed in values.
  vec3.raw(num x_, num y_, num z_) {
    x = x_;
    y = y_;
    z = z_;
  }
  /// Constructs a new [vec3] that is initialized with values from [array] starting at [offset].
  vec3.array(Float32Array array, [int offset=0]) {
    int i = offset;
    x = array[i];
    i++;
    y = array[i];
    i++;
    z = array[i];
    i++;
  }
  /// Splats a scalar into all lanes of the vector.
  vec3 splat(num arg) {
    x = arg;
    y = arg;
    z = arg;
    return this;
  }
  /// Returns a printable string
  String toString() => '$x,$y,$z';
  /// Returns a new vec3 from -this
  vec3 operator -() => new vec3(-x, -y, -z);
  /// Returns a new vec3 from this - [other]
  vec3 operator-(vec3 other) => new vec3(x - other.x, y - other.y, z - other.z);
  /// Returns a new vec3 from this + [other]
  vec3 operator+(vec3 other) => new vec3(x + other.x, y + other.y, z + other.z);
  /// Returns a new vec3 divided by [other]
  vec3 operator/(Dynamic other) {
    if (other is num) {
      return new vec3(x / other, y / other, z / other);
    }
    if (other is vec3) {
      return new vec3(x / other.x, y / other.y, z / other.z);
    }
  }
  /// Returns a new vec3 scaled by [other]
  vec3 operator*(Dynamic other) {
    if (other is num) {
      return new vec3(x * other, y * other, z * other);
    }
    if (other is vec3) {
      return new vec3(x * other.x, y * other.y, z * other.z);
    }
  }
  /// Returns a component from vec3. This is indexed as an array with [i]
  num operator[](int i) {
    assert(i >= 0 && i < 3);
    switch (i) {
      case 0: return x;
      case 1: return y;
      case 2: return z;
    };
    return 0.0;
  }
  /// Assigns a component in vec3 the value in [v]. This is indexed as an array with [i]
  void operator[]=(int i, num v) {
    assert(i >= 0 && i < 3);
    switch (i) {
      case 0: x = v; break;
      case 1: y = v; break;
      case 2: z = v; break;
    };
  }
  /// Returns length of this
  num get length() {
    num sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    sum += (z * z);
    return Math.sqrt(sum);
  }
  /// Returns squared length of this
  num get length2() {
    num sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    sum += (z * z);
    return sum;
  }
  /// Normalizes this
  vec3 normalize() {
    num l = length;
    if (l == 0.0) {
      return this;
    }
    x /= l;
    y /= l;
    z /= l;
    return this;
  }
  /// Normalizes this returns new vector or optional [out]
  vec3 normalized([vec3 out = null]) {
    if (out == null) {
      out = new vec3.raw(x, y, z);
    }
    num l = out.length;
    if (l == 0.0) {
      return out;
    }
    out.x /= l;
    out.y /= l;
    out.z /= l;
    return out;
  }
  /// Returns the dot product of [this] and [other]
  num dot(vec3 other) {
    num sum = 0.0;
    sum += (x * other.x);
    sum += (y * other.y);
    sum += (z * other.z);
    return sum;
  }
  /// Returns the cross product of [this] and [other], optionally pass in output storage [out]
  vec3 cross(vec3 other, [vec3 out=null]) {
    if (out == null) {
      out = new vec3.zero();
    }
    out.x = y * other.z - z * other.y;
    out.y = z * other.x - x * other.z;
    out.z = x * other.y - y * other.x;
    return out;
  }
  /// Returns the relative error between [this] and [correct]
  num relativeError(vec3 correct) {
    num this_norm = length;
    num correct_norm = correct.length;
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  /// Returns the absolute error between [this] and [correct]
  num absoluteError(vec3 correct) {
    num this_norm = length;
    num correct_norm = correct.length;
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm;
  }
  set xy(vec2 arg) {
    x = arg.x;
    y = arg.y;
  }
  set xz(vec2 arg) {
    x = arg.x;
    z = arg.y;
  }
  set yx(vec2 arg) {
    y = arg.x;
    x = arg.y;
  }
  set yz(vec2 arg) {
    y = arg.x;
    z = arg.y;
  }
  set zx(vec2 arg) {
    z = arg.x;
    x = arg.y;
  }
  set zy(vec2 arg) {
    z = arg.x;
    y = arg.y;
  }
  set xyz(vec3 arg) {
    x = arg.x;
    y = arg.y;
    z = arg.z;
  }
  set xzy(vec3 arg) {
    x = arg.x;
    z = arg.y;
    y = arg.z;
  }
  set yxz(vec3 arg) {
    y = arg.x;
    x = arg.y;
    z = arg.z;
  }
  set yzx(vec3 arg) {
    y = arg.x;
    z = arg.y;
    x = arg.z;
  }
  set zxy(vec3 arg) {
    z = arg.x;
    x = arg.y;
    y = arg.z;
  }
  set zyx(vec3 arg) {
    z = arg.x;
    y = arg.y;
    x = arg.z;
  }
  /// Returns true if any component is infinite.
  bool isInfinite() {
    bool is_infinite = false;
    is_infinite = is_infinite || x.isInfinite();
    is_infinite = is_infinite || y.isInfinite();
    is_infinite = is_infinite || z.isInfinite();
    return is_infinite;
  }
  /// Returns true if any component is NaN.
  bool isNaN() {
    bool is_nan = false;
    is_nan = is_nan || x.isNaN();
    is_nan = is_nan || y.isNaN();
    is_nan = is_nan || z.isNaN();
    return is_nan;
  }
  set r(num arg) => x = arg;
  set g(num arg) => y = arg;
  set b(num arg) => z = arg;
  set s(num arg) => x = arg;
  set t(num arg) => y = arg;
  set p(num arg) => z = arg;
  set rg(vec2 arg) {
    r = arg.r;
    g = arg.g;
  }
  set rb(vec2 arg) {
    r = arg.r;
    b = arg.g;
  }
  set gr(vec2 arg) {
    g = arg.r;
    r = arg.g;
  }
  set gb(vec2 arg) {
    g = arg.r;
    b = arg.g;
  }
  set br(vec2 arg) {
    b = arg.r;
    r = arg.g;
  }
  set bg(vec2 arg) {
    b = arg.r;
    g = arg.g;
  }
  set rgb(vec3 arg) {
    r = arg.r;
    g = arg.g;
    b = arg.b;
  }
  set rbg(vec3 arg) {
    r = arg.r;
    b = arg.g;
    g = arg.b;
  }
  set grb(vec3 arg) {
    g = arg.r;
    r = arg.g;
    b = arg.b;
  }
  set gbr(vec3 arg) {
    g = arg.r;
    b = arg.g;
    r = arg.b;
  }
  set brg(vec3 arg) {
    b = arg.r;
    r = arg.g;
    g = arg.b;
  }
  set bgr(vec3 arg) {
    b = arg.r;
    g = arg.g;
    r = arg.b;
  }
  set st(vec2 arg) {
    s = arg.s;
    t = arg.t;
  }
  set sp(vec2 arg) {
    s = arg.s;
    p = arg.t;
  }
  set ts(vec2 arg) {
    t = arg.s;
    s = arg.t;
  }
  set tp(vec2 arg) {
    t = arg.s;
    p = arg.t;
  }
  set ps(vec2 arg) {
    p = arg.s;
    s = arg.t;
  }
  set pt(vec2 arg) {
    p = arg.s;
    t = arg.t;
  }
  set stp(vec3 arg) {
    s = arg.s;
    t = arg.t;
    p = arg.p;
  }
  set spt(vec3 arg) {
    s = arg.s;
    p = arg.t;
    t = arg.p;
  }
  set tsp(vec3 arg) {
    t = arg.s;
    s = arg.t;
    p = arg.p;
  }
  set tps(vec3 arg) {
    t = arg.s;
    p = arg.t;
    s = arg.p;
  }
  set pst(vec3 arg) {
    p = arg.s;
    s = arg.t;
    t = arg.p;
  }
  set pts(vec3 arg) {
    p = arg.s;
    t = arg.t;
    s = arg.p;
  }
  vec2 get xx() => new vec2(x, x);
  vec2 get xy() => new vec2(x, y);
  vec2 get xz() => new vec2(x, z);
  vec2 get yx() => new vec2(y, x);
  vec2 get yy() => new vec2(y, y);
  vec2 get yz() => new vec2(y, z);
  vec2 get zx() => new vec2(z, x);
  vec2 get zy() => new vec2(z, y);
  vec2 get zz() => new vec2(z, z);
  vec3 get xxx() => new vec3(x, x, x);
  vec3 get xxy() => new vec3(x, x, y);
  vec3 get xxz() => new vec3(x, x, z);
  vec3 get xyx() => new vec3(x, y, x);
  vec3 get xyy() => new vec3(x, y, y);
  vec3 get xyz() => new vec3(x, y, z);
  vec3 get xzx() => new vec3(x, z, x);
  vec3 get xzy() => new vec3(x, z, y);
  vec3 get xzz() => new vec3(x, z, z);
  vec3 get yxx() => new vec3(y, x, x);
  vec3 get yxy() => new vec3(y, x, y);
  vec3 get yxz() => new vec3(y, x, z);
  vec3 get yyx() => new vec3(y, y, x);
  vec3 get yyy() => new vec3(y, y, y);
  vec3 get yyz() => new vec3(y, y, z);
  vec3 get yzx() => new vec3(y, z, x);
  vec3 get yzy() => new vec3(y, z, y);
  vec3 get yzz() => new vec3(y, z, z);
  vec3 get zxx() => new vec3(z, x, x);
  vec3 get zxy() => new vec3(z, x, y);
  vec3 get zxz() => new vec3(z, x, z);
  vec3 get zyx() => new vec3(z, y, x);
  vec3 get zyy() => new vec3(z, y, y);
  vec3 get zyz() => new vec3(z, y, z);
  vec3 get zzx() => new vec3(z, z, x);
  vec3 get zzy() => new vec3(z, z, y);
  vec3 get zzz() => new vec3(z, z, z);
  vec4 get xxxx() => new vec4(x, x, x, x);
  vec4 get xxxy() => new vec4(x, x, x, y);
  vec4 get xxxz() => new vec4(x, x, x, z);
  vec4 get xxyx() => new vec4(x, x, y, x);
  vec4 get xxyy() => new vec4(x, x, y, y);
  vec4 get xxyz() => new vec4(x, x, y, z);
  vec4 get xxzx() => new vec4(x, x, z, x);
  vec4 get xxzy() => new vec4(x, x, z, y);
  vec4 get xxzz() => new vec4(x, x, z, z);
  vec4 get xyxx() => new vec4(x, y, x, x);
  vec4 get xyxy() => new vec4(x, y, x, y);
  vec4 get xyxz() => new vec4(x, y, x, z);
  vec4 get xyyx() => new vec4(x, y, y, x);
  vec4 get xyyy() => new vec4(x, y, y, y);
  vec4 get xyyz() => new vec4(x, y, y, z);
  vec4 get xyzx() => new vec4(x, y, z, x);
  vec4 get xyzy() => new vec4(x, y, z, y);
  vec4 get xyzz() => new vec4(x, y, z, z);
  vec4 get xzxx() => new vec4(x, z, x, x);
  vec4 get xzxy() => new vec4(x, z, x, y);
  vec4 get xzxz() => new vec4(x, z, x, z);
  vec4 get xzyx() => new vec4(x, z, y, x);
  vec4 get xzyy() => new vec4(x, z, y, y);
  vec4 get xzyz() => new vec4(x, z, y, z);
  vec4 get xzzx() => new vec4(x, z, z, x);
  vec4 get xzzy() => new vec4(x, z, z, y);
  vec4 get xzzz() => new vec4(x, z, z, z);
  vec4 get yxxx() => new vec4(y, x, x, x);
  vec4 get yxxy() => new vec4(y, x, x, y);
  vec4 get yxxz() => new vec4(y, x, x, z);
  vec4 get yxyx() => new vec4(y, x, y, x);
  vec4 get yxyy() => new vec4(y, x, y, y);
  vec4 get yxyz() => new vec4(y, x, y, z);
  vec4 get yxzx() => new vec4(y, x, z, x);
  vec4 get yxzy() => new vec4(y, x, z, y);
  vec4 get yxzz() => new vec4(y, x, z, z);
  vec4 get yyxx() => new vec4(y, y, x, x);
  vec4 get yyxy() => new vec4(y, y, x, y);
  vec4 get yyxz() => new vec4(y, y, x, z);
  vec4 get yyyx() => new vec4(y, y, y, x);
  vec4 get yyyy() => new vec4(y, y, y, y);
  vec4 get yyyz() => new vec4(y, y, y, z);
  vec4 get yyzx() => new vec4(y, y, z, x);
  vec4 get yyzy() => new vec4(y, y, z, y);
  vec4 get yyzz() => new vec4(y, y, z, z);
  vec4 get yzxx() => new vec4(y, z, x, x);
  vec4 get yzxy() => new vec4(y, z, x, y);
  vec4 get yzxz() => new vec4(y, z, x, z);
  vec4 get yzyx() => new vec4(y, z, y, x);
  vec4 get yzyy() => new vec4(y, z, y, y);
  vec4 get yzyz() => new vec4(y, z, y, z);
  vec4 get yzzx() => new vec4(y, z, z, x);
  vec4 get yzzy() => new vec4(y, z, z, y);
  vec4 get yzzz() => new vec4(y, z, z, z);
  vec4 get zxxx() => new vec4(z, x, x, x);
  vec4 get zxxy() => new vec4(z, x, x, y);
  vec4 get zxxz() => new vec4(z, x, x, z);
  vec4 get zxyx() => new vec4(z, x, y, x);
  vec4 get zxyy() => new vec4(z, x, y, y);
  vec4 get zxyz() => new vec4(z, x, y, z);
  vec4 get zxzx() => new vec4(z, x, z, x);
  vec4 get zxzy() => new vec4(z, x, z, y);
  vec4 get zxzz() => new vec4(z, x, z, z);
  vec4 get zyxx() => new vec4(z, y, x, x);
  vec4 get zyxy() => new vec4(z, y, x, y);
  vec4 get zyxz() => new vec4(z, y, x, z);
  vec4 get zyyx() => new vec4(z, y, y, x);
  vec4 get zyyy() => new vec4(z, y, y, y);
  vec4 get zyyz() => new vec4(z, y, y, z);
  vec4 get zyzx() => new vec4(z, y, z, x);
  vec4 get zyzy() => new vec4(z, y, z, y);
  vec4 get zyzz() => new vec4(z, y, z, z);
  vec4 get zzxx() => new vec4(z, z, x, x);
  vec4 get zzxy() => new vec4(z, z, x, y);
  vec4 get zzxz() => new vec4(z, z, x, z);
  vec4 get zzyx() => new vec4(z, z, y, x);
  vec4 get zzyy() => new vec4(z, z, y, y);
  vec4 get zzyz() => new vec4(z, z, y, z);
  vec4 get zzzx() => new vec4(z, z, z, x);
  vec4 get zzzy() => new vec4(z, z, z, y);
  vec4 get zzzz() => new vec4(z, z, z, z);
  num get r() => x;
  num get g() => y;
  num get b() => z;
  num get s() => x;
  num get t() => y;
  num get p() => z;
  vec2 get rr() => new vec2(r, r);
  vec2 get rg() => new vec2(r, g);
  vec2 get rb() => new vec2(r, b);
  vec2 get gr() => new vec2(g, r);
  vec2 get gg() => new vec2(g, g);
  vec2 get gb() => new vec2(g, b);
  vec2 get br() => new vec2(b, r);
  vec2 get bg() => new vec2(b, g);
  vec2 get bb() => new vec2(b, b);
  vec3 get rrr() => new vec3(r, r, r);
  vec3 get rrg() => new vec3(r, r, g);
  vec3 get rrb() => new vec3(r, r, b);
  vec3 get rgr() => new vec3(r, g, r);
  vec3 get rgg() => new vec3(r, g, g);
  vec3 get rgb() => new vec3(r, g, b);
  vec3 get rbr() => new vec3(r, b, r);
  vec3 get rbg() => new vec3(r, b, g);
  vec3 get rbb() => new vec3(r, b, b);
  vec3 get grr() => new vec3(g, r, r);
  vec3 get grg() => new vec3(g, r, g);
  vec3 get grb() => new vec3(g, r, b);
  vec3 get ggr() => new vec3(g, g, r);
  vec3 get ggg() => new vec3(g, g, g);
  vec3 get ggb() => new vec3(g, g, b);
  vec3 get gbr() => new vec3(g, b, r);
  vec3 get gbg() => new vec3(g, b, g);
  vec3 get gbb() => new vec3(g, b, b);
  vec3 get brr() => new vec3(b, r, r);
  vec3 get brg() => new vec3(b, r, g);
  vec3 get brb() => new vec3(b, r, b);
  vec3 get bgr() => new vec3(b, g, r);
  vec3 get bgg() => new vec3(b, g, g);
  vec3 get bgb() => new vec3(b, g, b);
  vec3 get bbr() => new vec3(b, b, r);
  vec3 get bbg() => new vec3(b, b, g);
  vec3 get bbb() => new vec3(b, b, b);
  vec4 get rrrr() => new vec4(r, r, r, r);
  vec4 get rrrg() => new vec4(r, r, r, g);
  vec4 get rrrb() => new vec4(r, r, r, b);
  vec4 get rrgr() => new vec4(r, r, g, r);
  vec4 get rrgg() => new vec4(r, r, g, g);
  vec4 get rrgb() => new vec4(r, r, g, b);
  vec4 get rrbr() => new vec4(r, r, b, r);
  vec4 get rrbg() => new vec4(r, r, b, g);
  vec4 get rrbb() => new vec4(r, r, b, b);
  vec4 get rgrr() => new vec4(r, g, r, r);
  vec4 get rgrg() => new vec4(r, g, r, g);
  vec4 get rgrb() => new vec4(r, g, r, b);
  vec4 get rggr() => new vec4(r, g, g, r);
  vec4 get rggg() => new vec4(r, g, g, g);
  vec4 get rggb() => new vec4(r, g, g, b);
  vec4 get rgbr() => new vec4(r, g, b, r);
  vec4 get rgbg() => new vec4(r, g, b, g);
  vec4 get rgbb() => new vec4(r, g, b, b);
  vec4 get rbrr() => new vec4(r, b, r, r);
  vec4 get rbrg() => new vec4(r, b, r, g);
  vec4 get rbrb() => new vec4(r, b, r, b);
  vec4 get rbgr() => new vec4(r, b, g, r);
  vec4 get rbgg() => new vec4(r, b, g, g);
  vec4 get rbgb() => new vec4(r, b, g, b);
  vec4 get rbbr() => new vec4(r, b, b, r);
  vec4 get rbbg() => new vec4(r, b, b, g);
  vec4 get rbbb() => new vec4(r, b, b, b);
  vec4 get grrr() => new vec4(g, r, r, r);
  vec4 get grrg() => new vec4(g, r, r, g);
  vec4 get grrb() => new vec4(g, r, r, b);
  vec4 get grgr() => new vec4(g, r, g, r);
  vec4 get grgg() => new vec4(g, r, g, g);
  vec4 get grgb() => new vec4(g, r, g, b);
  vec4 get grbr() => new vec4(g, r, b, r);
  vec4 get grbg() => new vec4(g, r, b, g);
  vec4 get grbb() => new vec4(g, r, b, b);
  vec4 get ggrr() => new vec4(g, g, r, r);
  vec4 get ggrg() => new vec4(g, g, r, g);
  vec4 get ggrb() => new vec4(g, g, r, b);
  vec4 get gggr() => new vec4(g, g, g, r);
  vec4 get gggg() => new vec4(g, g, g, g);
  vec4 get gggb() => new vec4(g, g, g, b);
  vec4 get ggbr() => new vec4(g, g, b, r);
  vec4 get ggbg() => new vec4(g, g, b, g);
  vec4 get ggbb() => new vec4(g, g, b, b);
  vec4 get gbrr() => new vec4(g, b, r, r);
  vec4 get gbrg() => new vec4(g, b, r, g);
  vec4 get gbrb() => new vec4(g, b, r, b);
  vec4 get gbgr() => new vec4(g, b, g, r);
  vec4 get gbgg() => new vec4(g, b, g, g);
  vec4 get gbgb() => new vec4(g, b, g, b);
  vec4 get gbbr() => new vec4(g, b, b, r);
  vec4 get gbbg() => new vec4(g, b, b, g);
  vec4 get gbbb() => new vec4(g, b, b, b);
  vec4 get brrr() => new vec4(b, r, r, r);
  vec4 get brrg() => new vec4(b, r, r, g);
  vec4 get brrb() => new vec4(b, r, r, b);
  vec4 get brgr() => new vec4(b, r, g, r);
  vec4 get brgg() => new vec4(b, r, g, g);
  vec4 get brgb() => new vec4(b, r, g, b);
  vec4 get brbr() => new vec4(b, r, b, r);
  vec4 get brbg() => new vec4(b, r, b, g);
  vec4 get brbb() => new vec4(b, r, b, b);
  vec4 get bgrr() => new vec4(b, g, r, r);
  vec4 get bgrg() => new vec4(b, g, r, g);
  vec4 get bgrb() => new vec4(b, g, r, b);
  vec4 get bggr() => new vec4(b, g, g, r);
  vec4 get bggg() => new vec4(b, g, g, g);
  vec4 get bggb() => new vec4(b, g, g, b);
  vec4 get bgbr() => new vec4(b, g, b, r);
  vec4 get bgbg() => new vec4(b, g, b, g);
  vec4 get bgbb() => new vec4(b, g, b, b);
  vec4 get bbrr() => new vec4(b, b, r, r);
  vec4 get bbrg() => new vec4(b, b, r, g);
  vec4 get bbrb() => new vec4(b, b, r, b);
  vec4 get bbgr() => new vec4(b, b, g, r);
  vec4 get bbgg() => new vec4(b, b, g, g);
  vec4 get bbgb() => new vec4(b, b, g, b);
  vec4 get bbbr() => new vec4(b, b, b, r);
  vec4 get bbbg() => new vec4(b, b, b, g);
  vec4 get bbbb() => new vec4(b, b, b, b);
  vec2 get ss() => new vec2(s, s);
  vec2 get st() => new vec2(s, t);
  vec2 get sp() => new vec2(s, p);
  vec2 get ts() => new vec2(t, s);
  vec2 get tt() => new vec2(t, t);
  vec2 get tp() => new vec2(t, p);
  vec2 get ps() => new vec2(p, s);
  vec2 get pt() => new vec2(p, t);
  vec2 get pp() => new vec2(p, p);
  vec3 get sss() => new vec3(s, s, s);
  vec3 get sst() => new vec3(s, s, t);
  vec3 get ssp() => new vec3(s, s, p);
  vec3 get sts() => new vec3(s, t, s);
  vec3 get stt() => new vec3(s, t, t);
  vec3 get stp() => new vec3(s, t, p);
  vec3 get sps() => new vec3(s, p, s);
  vec3 get spt() => new vec3(s, p, t);
  vec3 get spp() => new vec3(s, p, p);
  vec3 get tss() => new vec3(t, s, s);
  vec3 get tst() => new vec3(t, s, t);
  vec3 get tsp() => new vec3(t, s, p);
  vec3 get tts() => new vec3(t, t, s);
  vec3 get ttt() => new vec3(t, t, t);
  vec3 get ttp() => new vec3(t, t, p);
  vec3 get tps() => new vec3(t, p, s);
  vec3 get tpt() => new vec3(t, p, t);
  vec3 get tpp() => new vec3(t, p, p);
  vec3 get pss() => new vec3(p, s, s);
  vec3 get pst() => new vec3(p, s, t);
  vec3 get psp() => new vec3(p, s, p);
  vec3 get pts() => new vec3(p, t, s);
  vec3 get ptt() => new vec3(p, t, t);
  vec3 get ptp() => new vec3(p, t, p);
  vec3 get pps() => new vec3(p, p, s);
  vec3 get ppt() => new vec3(p, p, t);
  vec3 get ppp() => new vec3(p, p, p);
  vec4 get ssss() => new vec4(s, s, s, s);
  vec4 get ssst() => new vec4(s, s, s, t);
  vec4 get sssp() => new vec4(s, s, s, p);
  vec4 get ssts() => new vec4(s, s, t, s);
  vec4 get sstt() => new vec4(s, s, t, t);
  vec4 get sstp() => new vec4(s, s, t, p);
  vec4 get ssps() => new vec4(s, s, p, s);
  vec4 get sspt() => new vec4(s, s, p, t);
  vec4 get sspp() => new vec4(s, s, p, p);
  vec4 get stss() => new vec4(s, t, s, s);
  vec4 get stst() => new vec4(s, t, s, t);
  vec4 get stsp() => new vec4(s, t, s, p);
  vec4 get stts() => new vec4(s, t, t, s);
  vec4 get sttt() => new vec4(s, t, t, t);
  vec4 get sttp() => new vec4(s, t, t, p);
  vec4 get stps() => new vec4(s, t, p, s);
  vec4 get stpt() => new vec4(s, t, p, t);
  vec4 get stpp() => new vec4(s, t, p, p);
  vec4 get spss() => new vec4(s, p, s, s);
  vec4 get spst() => new vec4(s, p, s, t);
  vec4 get spsp() => new vec4(s, p, s, p);
  vec4 get spts() => new vec4(s, p, t, s);
  vec4 get sptt() => new vec4(s, p, t, t);
  vec4 get sptp() => new vec4(s, p, t, p);
  vec4 get spps() => new vec4(s, p, p, s);
  vec4 get sppt() => new vec4(s, p, p, t);
  vec4 get sppp() => new vec4(s, p, p, p);
  vec4 get tsss() => new vec4(t, s, s, s);
  vec4 get tsst() => new vec4(t, s, s, t);
  vec4 get tssp() => new vec4(t, s, s, p);
  vec4 get tsts() => new vec4(t, s, t, s);
  vec4 get tstt() => new vec4(t, s, t, t);
  vec4 get tstp() => new vec4(t, s, t, p);
  vec4 get tsps() => new vec4(t, s, p, s);
  vec4 get tspt() => new vec4(t, s, p, t);
  vec4 get tspp() => new vec4(t, s, p, p);
  vec4 get ttss() => new vec4(t, t, s, s);
  vec4 get ttst() => new vec4(t, t, s, t);
  vec4 get ttsp() => new vec4(t, t, s, p);
  vec4 get ttts() => new vec4(t, t, t, s);
  vec4 get tttt() => new vec4(t, t, t, t);
  vec4 get tttp() => new vec4(t, t, t, p);
  vec4 get ttps() => new vec4(t, t, p, s);
  vec4 get ttpt() => new vec4(t, t, p, t);
  vec4 get ttpp() => new vec4(t, t, p, p);
  vec4 get tpss() => new vec4(t, p, s, s);
  vec4 get tpst() => new vec4(t, p, s, t);
  vec4 get tpsp() => new vec4(t, p, s, p);
  vec4 get tpts() => new vec4(t, p, t, s);
  vec4 get tptt() => new vec4(t, p, t, t);
  vec4 get tptp() => new vec4(t, p, t, p);
  vec4 get tpps() => new vec4(t, p, p, s);
  vec4 get tppt() => new vec4(t, p, p, t);
  vec4 get tppp() => new vec4(t, p, p, p);
  vec4 get psss() => new vec4(p, s, s, s);
  vec4 get psst() => new vec4(p, s, s, t);
  vec4 get pssp() => new vec4(p, s, s, p);
  vec4 get psts() => new vec4(p, s, t, s);
  vec4 get pstt() => new vec4(p, s, t, t);
  vec4 get pstp() => new vec4(p, s, t, p);
  vec4 get psps() => new vec4(p, s, p, s);
  vec4 get pspt() => new vec4(p, s, p, t);
  vec4 get pspp() => new vec4(p, s, p, p);
  vec4 get ptss() => new vec4(p, t, s, s);
  vec4 get ptst() => new vec4(p, t, s, t);
  vec4 get ptsp() => new vec4(p, t, s, p);
  vec4 get ptts() => new vec4(p, t, t, s);
  vec4 get pttt() => new vec4(p, t, t, t);
  vec4 get pttp() => new vec4(p, t, t, p);
  vec4 get ptps() => new vec4(p, t, p, s);
  vec4 get ptpt() => new vec4(p, t, p, t);
  vec4 get ptpp() => new vec4(p, t, p, p);
  vec4 get ppss() => new vec4(p, p, s, s);
  vec4 get ppst() => new vec4(p, p, s, t);
  vec4 get ppsp() => new vec4(p, p, s, p);
  vec4 get ppts() => new vec4(p, p, t, s);
  vec4 get pptt() => new vec4(p, p, t, t);
  vec4 get pptp() => new vec4(p, p, t, p);
  vec4 get ppps() => new vec4(p, p, p, s);
  vec4 get pppt() => new vec4(p, p, p, t);
  vec4 get pppp() => new vec4(p, p, p, p);
  vec3 add(vec3 arg) {
    x = x + arg.x;
    y = y + arg.y;
    z = z + arg.z;
    return this;
  }
  vec3 sub(vec3 arg) {
    x = x - arg.x;
    y = y - arg.y;
    z = z - arg.z;
    return this;
  }
  vec3 multiply(vec3 arg) {
    x = x * arg.x;
    y = y * arg.y;
    z = z * arg.z;
    return this;
  }
  vec3 div(vec3 arg) {
    x = x / arg.x;
    y = y / arg.y;
    z = z / arg.z;
    return this;
  }
  vec3 scale(num arg) {
    x = x * arg;
    y = y * arg;
    z = z * arg;
    return this;
  }
  vec3 negate() {
    x = -x;
    y = -y;
    z = -z;
    return this;
  }
  vec3 absolute() {
    x = x.abs();
    y = y.abs();
    z = z.abs();
    return this;
  }
  vec3 copyInto(vec3 arg) {
    arg.x = x;
    arg.y = y;
    arg.z = z;
    return arg;
  }
  vec3 copyFrom(vec3 arg) {
    x = arg.x;
    y = arg.y;
    z = arg.z;
    return this;
  }
  vec3 set(vec3 arg) {
    x = arg.x;
    y = arg.y;
    z = arg.z;
    return this;
  }
  vec3 setComponents(num x_, num y_, num z_) {
    x = x_;
    y = y_;
    z = z_;
    return this;
  }
  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(Float32Array array, [int offset=0]) {
    int i = offset;
    array[i] = x;
    i++;
    array[i] = y;
    i++;
    array[i] = z;
    i++;
  }
  /// Returns a copy of [this] as a [Float32Array].
  Float32Array copyAsArray() {
    Float32Array array = new Float32Array(3);
    int i = 0;
    array[i] = x;
    i++;
    array[i] = y;
    i++;
    array[i] = z;
    i++;
    return array;
  }
  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(Float32Array array, [int offset=0]) {
    int i = offset;
    x = array[i];
    i++;
    y = array[i];
    i++;
    z = array[i];
    i++;
  }
}
