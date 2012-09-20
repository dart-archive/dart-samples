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
class vec4 {
  num x;
  num y;
  num z;
  num w;
  /// Constructs a new [vec4]. Follows GLSL constructor syntax so many combinations are possible
  vec4([Dynamic x_, Dynamic y_, Dynamic z_, Dynamic w_]) {
    x = y = z = w = 0.0;
    if (x_ is vec3 && y_ is num) {
      this.xyz = x_.xyz;
      this.w = y_;
    }
    if (x_ is num && y_ is vec3) {
      this.x = x_;
      this.yzw = y_.xyz;
    }
    if (x_ is vec3 && y_ == null) {
      this.xyz = x_.xyz;
      this.z = 0;
    }
    if (x_ is vec2 && y_ is vec2) {
      this.xy = x_.xy;
      this.zw = y_.xy;
    }
    if (x_ is vec4) {
      xyzw = x_.xyzw;
      return;
    }
    if (x_ is num && y_ is num && z_ is num && w_ is num) {
      x = x_;
      y = y_;
      z = z_;
      w = w_;
      return;
    }
    if (x_ is num) {
      x = y = z = w = x_;
      return;
    }
  }
  /// Constructs a new [vec4] filled with 0.
  vec4.zero() {
    x = 0.0;
    y = 0.0;
    z = 0.0;
    w = 0.0;
  }
  /// Constructs a new [vec4] that is a copy of [other].
  vec4.copy(vec4 other) {
    x = other.x;
    y = other.y;
    z = other.z;
    w = other.w;
  }
  /// Constructs a new [vec4] that is initialized with passed in values.
  vec4.raw(num x_, num y_, num z_, num w_) {
    x = x_;
    y = y_;
    z = z_;
    w = w_;
  }
  /// Constructs a new [vec4] that is initialized with values from [array] starting at [offset].
  vec4.array(Float32Array array, [int offset=0]) {
    int i = offset;
    x = array[i];
    i++;
    y = array[i];
    i++;
    z = array[i];
    i++;
    w = array[i];
    i++;
  }
  /// Splats a scalar into all lanes of the vector.
  vec4 splat(num arg) {
    x = arg;
    y = arg;
    z = arg;
    w = arg;
    return this;
  }
  /// Returns a printable string
  String toString() => '$x,$y,$z,$w';
  /// Returns a new vec4 from -this
  vec4 operator -() => new vec4(-x, -y, -z, -w);
  /// Returns a new vec4 from this - [other]
  vec4 operator-(vec4 other) => new vec4(x - other.x, y - other.y, z - other.z, w - other.w);
  /// Returns a new vec4 from this + [other]
  vec4 operator+(vec4 other) => new vec4(x + other.x, y + other.y, z + other.z, w + other.w);
  /// Returns a new vec4 divided by [other]
  vec4 operator/(Dynamic other) {
    if (other is num) {
      return new vec4(x / other, y / other, z / other, w / other);
    }
    if (other is vec4) {
      return new vec4(x / other.x, y / other.y, z / other.z, w / other.w);
    }
  }
  /// Returns a new vec4 scaled by [other]
  vec4 operator*(Dynamic other) {
    if (other is num) {
      return new vec4(x * other, y * other, z * other, w * other);
    }
    if (other is vec4) {
      return new vec4(x * other.x, y * other.y, z * other.z, w * other.w);
    }
  }
  /// Returns a component from vec4. This is indexed as an array with [i]
  num operator[](int i) {
    assert(i >= 0 && i < 4);
    switch (i) {
      case 0: return x;
      case 1: return y;
      case 2: return z;
      case 3: return w;
    };
    return 0.0;
  }
  /// Assigns a component in vec4 the value in [v]. This is indexed as an array with [i]
  void operator[]=(int i, num v) {
    assert(i >= 0 && i < 4);
    switch (i) {
      case 0: x = v; break;
      case 1: y = v; break;
      case 2: z = v; break;
      case 3: w = v; break;
    };
  }
  /// Returns length of this
  num get length() {
    num sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    sum += (z * z);
    sum += (w * w);
    return Math.sqrt(sum);
  }
  /// Returns squared length of this
  num get length2() {
    num sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    sum += (z * z);
    sum += (w * w);
    return sum;
  }
  /// Normalizes this
  vec4 normalize() {
    num l = length;
    if (l == 0.0) {
      return this;
    }
    x /= l;
    y /= l;
    z /= l;
    w /= l;
    return this;
  }
  /// Normalizes this returns new vector or optional [out]
  vec4 normalized([vec4 out = null]) {
    if (out == null) {
      out = new vec4.raw(x, y, z, w);
    }
    num l = out.length;
    if (l == 0.0) {
      return out;
    }
    out.x /= l;
    out.y /= l;
    out.z /= l;
    out.w /= l;
    return out;
  }
  /// Returns the dot product of [this] and [other]
  num dot(vec4 other) {
    num sum = 0.0;
    sum += (x * other.x);
    sum += (y * other.y);
    sum += (z * other.z);
    sum += (w * other.w);
    return sum;
  }
  /// Returns the relative error between [this] and [correct]
  num relativeError(vec4 correct) {
    num this_norm = length;
    num correct_norm = correct.length;
    num diff_norm = (this_norm - correct_norm).abs();
    return diff_norm/correct_norm;
  }
  /// Returns the absolute error between [this] and [correct]
  num absoluteError(vec4 correct) {
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
  set xw(vec2 arg) {
    x = arg.x;
    w = arg.y;
  }
  set yx(vec2 arg) {
    y = arg.x;
    x = arg.y;
  }
  set yz(vec2 arg) {
    y = arg.x;
    z = arg.y;
  }
  set yw(vec2 arg) {
    y = arg.x;
    w = arg.y;
  }
  set zx(vec2 arg) {
    z = arg.x;
    x = arg.y;
  }
  set zy(vec2 arg) {
    z = arg.x;
    y = arg.y;
  }
  set zw(vec2 arg) {
    z = arg.x;
    w = arg.y;
  }
  set wx(vec2 arg) {
    w = arg.x;
    x = arg.y;
  }
  set wy(vec2 arg) {
    w = arg.x;
    y = arg.y;
  }
  set wz(vec2 arg) {
    w = arg.x;
    z = arg.y;
  }
  set xyz(vec3 arg) {
    x = arg.x;
    y = arg.y;
    z = arg.z;
  }
  set xyw(vec3 arg) {
    x = arg.x;
    y = arg.y;
    w = arg.z;
  }
  set xzy(vec3 arg) {
    x = arg.x;
    z = arg.y;
    y = arg.z;
  }
  set xzw(vec3 arg) {
    x = arg.x;
    z = arg.y;
    w = arg.z;
  }
  set xwy(vec3 arg) {
    x = arg.x;
    w = arg.y;
    y = arg.z;
  }
  set xwz(vec3 arg) {
    x = arg.x;
    w = arg.y;
    z = arg.z;
  }
  set yxz(vec3 arg) {
    y = arg.x;
    x = arg.y;
    z = arg.z;
  }
  set yxw(vec3 arg) {
    y = arg.x;
    x = arg.y;
    w = arg.z;
  }
  set yzx(vec3 arg) {
    y = arg.x;
    z = arg.y;
    x = arg.z;
  }
  set yzw(vec3 arg) {
    y = arg.x;
    z = arg.y;
    w = arg.z;
  }
  set ywx(vec3 arg) {
    y = arg.x;
    w = arg.y;
    x = arg.z;
  }
  set ywz(vec3 arg) {
    y = arg.x;
    w = arg.y;
    z = arg.z;
  }
  set zxy(vec3 arg) {
    z = arg.x;
    x = arg.y;
    y = arg.z;
  }
  set zxw(vec3 arg) {
    z = arg.x;
    x = arg.y;
    w = arg.z;
  }
  set zyx(vec3 arg) {
    z = arg.x;
    y = arg.y;
    x = arg.z;
  }
  set zyw(vec3 arg) {
    z = arg.x;
    y = arg.y;
    w = arg.z;
  }
  set zwx(vec3 arg) {
    z = arg.x;
    w = arg.y;
    x = arg.z;
  }
  set zwy(vec3 arg) {
    z = arg.x;
    w = arg.y;
    y = arg.z;
  }
  set wxy(vec3 arg) {
    w = arg.x;
    x = arg.y;
    y = arg.z;
  }
  set wxz(vec3 arg) {
    w = arg.x;
    x = arg.y;
    z = arg.z;
  }
  set wyx(vec3 arg) {
    w = arg.x;
    y = arg.y;
    x = arg.z;
  }
  set wyz(vec3 arg) {
    w = arg.x;
    y = arg.y;
    z = arg.z;
  }
  set wzx(vec3 arg) {
    w = arg.x;
    z = arg.y;
    x = arg.z;
  }
  set wzy(vec3 arg) {
    w = arg.x;
    z = arg.y;
    y = arg.z;
  }
  set xyzw(vec4 arg) {
    x = arg.x;
    y = arg.y;
    z = arg.z;
    w = arg.w;
  }
  set xywz(vec4 arg) {
    x = arg.x;
    y = arg.y;
    w = arg.z;
    z = arg.w;
  }
  set xzyw(vec4 arg) {
    x = arg.x;
    z = arg.y;
    y = arg.z;
    w = arg.w;
  }
  set xzwy(vec4 arg) {
    x = arg.x;
    z = arg.y;
    w = arg.z;
    y = arg.w;
  }
  set xwyz(vec4 arg) {
    x = arg.x;
    w = arg.y;
    y = arg.z;
    z = arg.w;
  }
  set xwzy(vec4 arg) {
    x = arg.x;
    w = arg.y;
    z = arg.z;
    y = arg.w;
  }
  set yxzw(vec4 arg) {
    y = arg.x;
    x = arg.y;
    z = arg.z;
    w = arg.w;
  }
  set yxwz(vec4 arg) {
    y = arg.x;
    x = arg.y;
    w = arg.z;
    z = arg.w;
  }
  set yzxw(vec4 arg) {
    y = arg.x;
    z = arg.y;
    x = arg.z;
    w = arg.w;
  }
  set yzwx(vec4 arg) {
    y = arg.x;
    z = arg.y;
    w = arg.z;
    x = arg.w;
  }
  set ywxz(vec4 arg) {
    y = arg.x;
    w = arg.y;
    x = arg.z;
    z = arg.w;
  }
  set ywzx(vec4 arg) {
    y = arg.x;
    w = arg.y;
    z = arg.z;
    x = arg.w;
  }
  set zxyw(vec4 arg) {
    z = arg.x;
    x = arg.y;
    y = arg.z;
    w = arg.w;
  }
  set zxwy(vec4 arg) {
    z = arg.x;
    x = arg.y;
    w = arg.z;
    y = arg.w;
  }
  set zyxw(vec4 arg) {
    z = arg.x;
    y = arg.y;
    x = arg.z;
    w = arg.w;
  }
  set zywx(vec4 arg) {
    z = arg.x;
    y = arg.y;
    w = arg.z;
    x = arg.w;
  }
  set zwxy(vec4 arg) {
    z = arg.x;
    w = arg.y;
    x = arg.z;
    y = arg.w;
  }
  set zwyx(vec4 arg) {
    z = arg.x;
    w = arg.y;
    y = arg.z;
    x = arg.w;
  }
  set wxyz(vec4 arg) {
    w = arg.x;
    x = arg.y;
    y = arg.z;
    z = arg.w;
  }
  set wxzy(vec4 arg) {
    w = arg.x;
    x = arg.y;
    z = arg.z;
    y = arg.w;
  }
  set wyxz(vec4 arg) {
    w = arg.x;
    y = arg.y;
    x = arg.z;
    z = arg.w;
  }
  set wyzx(vec4 arg) {
    w = arg.x;
    y = arg.y;
    z = arg.z;
    x = arg.w;
  }
  set wzxy(vec4 arg) {
    w = arg.x;
    z = arg.y;
    x = arg.z;
    y = arg.w;
  }
  set wzyx(vec4 arg) {
    w = arg.x;
    z = arg.y;
    y = arg.z;
    x = arg.w;
  }
  /// Returns true if any component is infinite.
  bool isInfinite() {
    bool is_infinite = false;
    is_infinite = is_infinite || x.isInfinite();
    is_infinite = is_infinite || y.isInfinite();
    is_infinite = is_infinite || z.isInfinite();
    is_infinite = is_infinite || w.isInfinite();
    return is_infinite;
  }
  /// Returns true if any component is NaN.
  bool isNaN() {
    bool is_nan = false;
    is_nan = is_nan || x.isNaN();
    is_nan = is_nan || y.isNaN();
    is_nan = is_nan || z.isNaN();
    is_nan = is_nan || w.isNaN();
    return is_nan;
  }
  set r(num arg) => x = arg;
  set g(num arg) => y = arg;
  set b(num arg) => z = arg;
  set a(num arg) => w = arg;
  set s(num arg) => x = arg;
  set t(num arg) => y = arg;
  set p(num arg) => z = arg;
  set q(num arg) => w = arg;
  set rg(vec2 arg) {
    r = arg.r;
    g = arg.g;
  }
  set rb(vec2 arg) {
    r = arg.r;
    b = arg.g;
  }
  set ra(vec2 arg) {
    r = arg.r;
    a = arg.g;
  }
  set gr(vec2 arg) {
    g = arg.r;
    r = arg.g;
  }
  set gb(vec2 arg) {
    g = arg.r;
    b = arg.g;
  }
  set ga(vec2 arg) {
    g = arg.r;
    a = arg.g;
  }
  set br(vec2 arg) {
    b = arg.r;
    r = arg.g;
  }
  set bg(vec2 arg) {
    b = arg.r;
    g = arg.g;
  }
  set ba(vec2 arg) {
    b = arg.r;
    a = arg.g;
  }
  set ar(vec2 arg) {
    a = arg.r;
    r = arg.g;
  }
  set ag(vec2 arg) {
    a = arg.r;
    g = arg.g;
  }
  set ab(vec2 arg) {
    a = arg.r;
    b = arg.g;
  }
  set rgb(vec3 arg) {
    r = arg.r;
    g = arg.g;
    b = arg.b;
  }
  set rga(vec3 arg) {
    r = arg.r;
    g = arg.g;
    a = arg.b;
  }
  set rbg(vec3 arg) {
    r = arg.r;
    b = arg.g;
    g = arg.b;
  }
  set rba(vec3 arg) {
    r = arg.r;
    b = arg.g;
    a = arg.b;
  }
  set rag(vec3 arg) {
    r = arg.r;
    a = arg.g;
    g = arg.b;
  }
  set rab(vec3 arg) {
    r = arg.r;
    a = arg.g;
    b = arg.b;
  }
  set grb(vec3 arg) {
    g = arg.r;
    r = arg.g;
    b = arg.b;
  }
  set gra(vec3 arg) {
    g = arg.r;
    r = arg.g;
    a = arg.b;
  }
  set gbr(vec3 arg) {
    g = arg.r;
    b = arg.g;
    r = arg.b;
  }
  set gba(vec3 arg) {
    g = arg.r;
    b = arg.g;
    a = arg.b;
  }
  set gar(vec3 arg) {
    g = arg.r;
    a = arg.g;
    r = arg.b;
  }
  set gab(vec3 arg) {
    g = arg.r;
    a = arg.g;
    b = arg.b;
  }
  set brg(vec3 arg) {
    b = arg.r;
    r = arg.g;
    g = arg.b;
  }
  set bra(vec3 arg) {
    b = arg.r;
    r = arg.g;
    a = arg.b;
  }
  set bgr(vec3 arg) {
    b = arg.r;
    g = arg.g;
    r = arg.b;
  }
  set bga(vec3 arg) {
    b = arg.r;
    g = arg.g;
    a = arg.b;
  }
  set bar(vec3 arg) {
    b = arg.r;
    a = arg.g;
    r = arg.b;
  }
  set bag(vec3 arg) {
    b = arg.r;
    a = arg.g;
    g = arg.b;
  }
  set arg(vec3 arg) {
    a = arg.r;
    r = arg.g;
    g = arg.b;
  }
  set arb(vec3 arg) {
    a = arg.r;
    r = arg.g;
    b = arg.b;
  }
  set agr(vec3 arg) {
    a = arg.r;
    g = arg.g;
    r = arg.b;
  }
  set agb(vec3 arg) {
    a = arg.r;
    g = arg.g;
    b = arg.b;
  }
  set abr(vec3 arg) {
    a = arg.r;
    b = arg.g;
    r = arg.b;
  }
  set abg(vec3 arg) {
    a = arg.r;
    b = arg.g;
    g = arg.b;
  }
  set rgba(vec4 arg) {
    r = arg.r;
    g = arg.g;
    b = arg.b;
    a = arg.a;
  }
  set rgab(vec4 arg) {
    r = arg.r;
    g = arg.g;
    a = arg.b;
    b = arg.a;
  }
  set rbga(vec4 arg) {
    r = arg.r;
    b = arg.g;
    g = arg.b;
    a = arg.a;
  }
  set rbag(vec4 arg) {
    r = arg.r;
    b = arg.g;
    a = arg.b;
    g = arg.a;
  }
  set ragb(vec4 arg) {
    r = arg.r;
    a = arg.g;
    g = arg.b;
    b = arg.a;
  }
  set rabg(vec4 arg) {
    r = arg.r;
    a = arg.g;
    b = arg.b;
    g = arg.a;
  }
  set grba(vec4 arg) {
    g = arg.r;
    r = arg.g;
    b = arg.b;
    a = arg.a;
  }
  set grab(vec4 arg) {
    g = arg.r;
    r = arg.g;
    a = arg.b;
    b = arg.a;
  }
  set gbra(vec4 arg) {
    g = arg.r;
    b = arg.g;
    r = arg.b;
    a = arg.a;
  }
  set gbar(vec4 arg) {
    g = arg.r;
    b = arg.g;
    a = arg.b;
    r = arg.a;
  }
  set garb(vec4 arg) {
    g = arg.r;
    a = arg.g;
    r = arg.b;
    b = arg.a;
  }
  set gabr(vec4 arg) {
    g = arg.r;
    a = arg.g;
    b = arg.b;
    r = arg.a;
  }
  set brga(vec4 arg) {
    b = arg.r;
    r = arg.g;
    g = arg.b;
    a = arg.a;
  }
  set brag(vec4 arg) {
    b = arg.r;
    r = arg.g;
    a = arg.b;
    g = arg.a;
  }
  set bgra(vec4 arg) {
    b = arg.r;
    g = arg.g;
    r = arg.b;
    a = arg.a;
  }
  set bgar(vec4 arg) {
    b = arg.r;
    g = arg.g;
    a = arg.b;
    r = arg.a;
  }
  set barg(vec4 arg) {
    b = arg.r;
    a = arg.g;
    r = arg.b;
    g = arg.a;
  }
  set bagr(vec4 arg) {
    b = arg.r;
    a = arg.g;
    g = arg.b;
    r = arg.a;
  }
  set argb(vec4 arg) {
    a = arg.r;
    r = arg.g;
    g = arg.b;
    b = arg.a;
  }
  set arbg(vec4 arg) {
    a = arg.r;
    r = arg.g;
    b = arg.b;
    g = arg.a;
  }
  set agrb(vec4 arg) {
    a = arg.r;
    g = arg.g;
    r = arg.b;
    b = arg.a;
  }
  set agbr(vec4 arg) {
    a = arg.r;
    g = arg.g;
    b = arg.b;
    r = arg.a;
  }
  set abrg(vec4 arg) {
    a = arg.r;
    b = arg.g;
    r = arg.b;
    g = arg.a;
  }
  set abgr(vec4 arg) {
    a = arg.r;
    b = arg.g;
    g = arg.b;
    r = arg.a;
  }
  set st(vec2 arg) {
    s = arg.s;
    t = arg.t;
  }
  set sp(vec2 arg) {
    s = arg.s;
    p = arg.t;
  }
  set sq(vec2 arg) {
    s = arg.s;
    q = arg.t;
  }
  set ts(vec2 arg) {
    t = arg.s;
    s = arg.t;
  }
  set tp(vec2 arg) {
    t = arg.s;
    p = arg.t;
  }
  set tq(vec2 arg) {
    t = arg.s;
    q = arg.t;
  }
  set ps(vec2 arg) {
    p = arg.s;
    s = arg.t;
  }
  set pt(vec2 arg) {
    p = arg.s;
    t = arg.t;
  }
  set pq(vec2 arg) {
    p = arg.s;
    q = arg.t;
  }
  set qs(vec2 arg) {
    q = arg.s;
    s = arg.t;
  }
  set qt(vec2 arg) {
    q = arg.s;
    t = arg.t;
  }
  set qp(vec2 arg) {
    q = arg.s;
    p = arg.t;
  }
  set stp(vec3 arg) {
    s = arg.s;
    t = arg.t;
    p = arg.p;
  }
  set stq(vec3 arg) {
    s = arg.s;
    t = arg.t;
    q = arg.p;
  }
  set spt(vec3 arg) {
    s = arg.s;
    p = arg.t;
    t = arg.p;
  }
  set spq(vec3 arg) {
    s = arg.s;
    p = arg.t;
    q = arg.p;
  }
  set sqt(vec3 arg) {
    s = arg.s;
    q = arg.t;
    t = arg.p;
  }
  set sqp(vec3 arg) {
    s = arg.s;
    q = arg.t;
    p = arg.p;
  }
  set tsp(vec3 arg) {
    t = arg.s;
    s = arg.t;
    p = arg.p;
  }
  set tsq(vec3 arg) {
    t = arg.s;
    s = arg.t;
    q = arg.p;
  }
  set tps(vec3 arg) {
    t = arg.s;
    p = arg.t;
    s = arg.p;
  }
  set tpq(vec3 arg) {
    t = arg.s;
    p = arg.t;
    q = arg.p;
  }
  set tqs(vec3 arg) {
    t = arg.s;
    q = arg.t;
    s = arg.p;
  }
  set tqp(vec3 arg) {
    t = arg.s;
    q = arg.t;
    p = arg.p;
  }
  set pst(vec3 arg) {
    p = arg.s;
    s = arg.t;
    t = arg.p;
  }
  set psq(vec3 arg) {
    p = arg.s;
    s = arg.t;
    q = arg.p;
  }
  set pts(vec3 arg) {
    p = arg.s;
    t = arg.t;
    s = arg.p;
  }
  set ptq(vec3 arg) {
    p = arg.s;
    t = arg.t;
    q = arg.p;
  }
  set pqs(vec3 arg) {
    p = arg.s;
    q = arg.t;
    s = arg.p;
  }
  set pqt(vec3 arg) {
    p = arg.s;
    q = arg.t;
    t = arg.p;
  }
  set qst(vec3 arg) {
    q = arg.s;
    s = arg.t;
    t = arg.p;
  }
  set qsp(vec3 arg) {
    q = arg.s;
    s = arg.t;
    p = arg.p;
  }
  set qts(vec3 arg) {
    q = arg.s;
    t = arg.t;
    s = arg.p;
  }
  set qtp(vec3 arg) {
    q = arg.s;
    t = arg.t;
    p = arg.p;
  }
  set qps(vec3 arg) {
    q = arg.s;
    p = arg.t;
    s = arg.p;
  }
  set qpt(vec3 arg) {
    q = arg.s;
    p = arg.t;
    t = arg.p;
  }
  set stpq(vec4 arg) {
    s = arg.s;
    t = arg.t;
    p = arg.p;
    q = arg.q;
  }
  set stqp(vec4 arg) {
    s = arg.s;
    t = arg.t;
    q = arg.p;
    p = arg.q;
  }
  set sptq(vec4 arg) {
    s = arg.s;
    p = arg.t;
    t = arg.p;
    q = arg.q;
  }
  set spqt(vec4 arg) {
    s = arg.s;
    p = arg.t;
    q = arg.p;
    t = arg.q;
  }
  set sqtp(vec4 arg) {
    s = arg.s;
    q = arg.t;
    t = arg.p;
    p = arg.q;
  }
  set sqpt(vec4 arg) {
    s = arg.s;
    q = arg.t;
    p = arg.p;
    t = arg.q;
  }
  set tspq(vec4 arg) {
    t = arg.s;
    s = arg.t;
    p = arg.p;
    q = arg.q;
  }
  set tsqp(vec4 arg) {
    t = arg.s;
    s = arg.t;
    q = arg.p;
    p = arg.q;
  }
  set tpsq(vec4 arg) {
    t = arg.s;
    p = arg.t;
    s = arg.p;
    q = arg.q;
  }
  set tpqs(vec4 arg) {
    t = arg.s;
    p = arg.t;
    q = arg.p;
    s = arg.q;
  }
  set tqsp(vec4 arg) {
    t = arg.s;
    q = arg.t;
    s = arg.p;
    p = arg.q;
  }
  set tqps(vec4 arg) {
    t = arg.s;
    q = arg.t;
    p = arg.p;
    s = arg.q;
  }
  set pstq(vec4 arg) {
    p = arg.s;
    s = arg.t;
    t = arg.p;
    q = arg.q;
  }
  set psqt(vec4 arg) {
    p = arg.s;
    s = arg.t;
    q = arg.p;
    t = arg.q;
  }
  set ptsq(vec4 arg) {
    p = arg.s;
    t = arg.t;
    s = arg.p;
    q = arg.q;
  }
  set ptqs(vec4 arg) {
    p = arg.s;
    t = arg.t;
    q = arg.p;
    s = arg.q;
  }
  set pqst(vec4 arg) {
    p = arg.s;
    q = arg.t;
    s = arg.p;
    t = arg.q;
  }
  set pqts(vec4 arg) {
    p = arg.s;
    q = arg.t;
    t = arg.p;
    s = arg.q;
  }
  set qstp(vec4 arg) {
    q = arg.s;
    s = arg.t;
    t = arg.p;
    p = arg.q;
  }
  set qspt(vec4 arg) {
    q = arg.s;
    s = arg.t;
    p = arg.p;
    t = arg.q;
  }
  set qtsp(vec4 arg) {
    q = arg.s;
    t = arg.t;
    s = arg.p;
    p = arg.q;
  }
  set qtps(vec4 arg) {
    q = arg.s;
    t = arg.t;
    p = arg.p;
    s = arg.q;
  }
  set qpst(vec4 arg) {
    q = arg.s;
    p = arg.t;
    s = arg.p;
    t = arg.q;
  }
  set qpts(vec4 arg) {
    q = arg.s;
    p = arg.t;
    t = arg.p;
    s = arg.q;
  }
  vec2 get xx() => new vec2(x, x);
  vec2 get xy() => new vec2(x, y);
  vec2 get xz() => new vec2(x, z);
  vec2 get xw() => new vec2(x, w);
  vec2 get yx() => new vec2(y, x);
  vec2 get yy() => new vec2(y, y);
  vec2 get yz() => new vec2(y, z);
  vec2 get yw() => new vec2(y, w);
  vec2 get zx() => new vec2(z, x);
  vec2 get zy() => new vec2(z, y);
  vec2 get zz() => new vec2(z, z);
  vec2 get zw() => new vec2(z, w);
  vec2 get wx() => new vec2(w, x);
  vec2 get wy() => new vec2(w, y);
  vec2 get wz() => new vec2(w, z);
  vec2 get ww() => new vec2(w, w);
  vec3 get xxx() => new vec3(x, x, x);
  vec3 get xxy() => new vec3(x, x, y);
  vec3 get xxz() => new vec3(x, x, z);
  vec3 get xxw() => new vec3(x, x, w);
  vec3 get xyx() => new vec3(x, y, x);
  vec3 get xyy() => new vec3(x, y, y);
  vec3 get xyz() => new vec3(x, y, z);
  vec3 get xyw() => new vec3(x, y, w);
  vec3 get xzx() => new vec3(x, z, x);
  vec3 get xzy() => new vec3(x, z, y);
  vec3 get xzz() => new vec3(x, z, z);
  vec3 get xzw() => new vec3(x, z, w);
  vec3 get xwx() => new vec3(x, w, x);
  vec3 get xwy() => new vec3(x, w, y);
  vec3 get xwz() => new vec3(x, w, z);
  vec3 get xww() => new vec3(x, w, w);
  vec3 get yxx() => new vec3(y, x, x);
  vec3 get yxy() => new vec3(y, x, y);
  vec3 get yxz() => new vec3(y, x, z);
  vec3 get yxw() => new vec3(y, x, w);
  vec3 get yyx() => new vec3(y, y, x);
  vec3 get yyy() => new vec3(y, y, y);
  vec3 get yyz() => new vec3(y, y, z);
  vec3 get yyw() => new vec3(y, y, w);
  vec3 get yzx() => new vec3(y, z, x);
  vec3 get yzy() => new vec3(y, z, y);
  vec3 get yzz() => new vec3(y, z, z);
  vec3 get yzw() => new vec3(y, z, w);
  vec3 get ywx() => new vec3(y, w, x);
  vec3 get ywy() => new vec3(y, w, y);
  vec3 get ywz() => new vec3(y, w, z);
  vec3 get yww() => new vec3(y, w, w);
  vec3 get zxx() => new vec3(z, x, x);
  vec3 get zxy() => new vec3(z, x, y);
  vec3 get zxz() => new vec3(z, x, z);
  vec3 get zxw() => new vec3(z, x, w);
  vec3 get zyx() => new vec3(z, y, x);
  vec3 get zyy() => new vec3(z, y, y);
  vec3 get zyz() => new vec3(z, y, z);
  vec3 get zyw() => new vec3(z, y, w);
  vec3 get zzx() => new vec3(z, z, x);
  vec3 get zzy() => new vec3(z, z, y);
  vec3 get zzz() => new vec3(z, z, z);
  vec3 get zzw() => new vec3(z, z, w);
  vec3 get zwx() => new vec3(z, w, x);
  vec3 get zwy() => new vec3(z, w, y);
  vec3 get zwz() => new vec3(z, w, z);
  vec3 get zww() => new vec3(z, w, w);
  vec3 get wxx() => new vec3(w, x, x);
  vec3 get wxy() => new vec3(w, x, y);
  vec3 get wxz() => new vec3(w, x, z);
  vec3 get wxw() => new vec3(w, x, w);
  vec3 get wyx() => new vec3(w, y, x);
  vec3 get wyy() => new vec3(w, y, y);
  vec3 get wyz() => new vec3(w, y, z);
  vec3 get wyw() => new vec3(w, y, w);
  vec3 get wzx() => new vec3(w, z, x);
  vec3 get wzy() => new vec3(w, z, y);
  vec3 get wzz() => new vec3(w, z, z);
  vec3 get wzw() => new vec3(w, z, w);
  vec3 get wwx() => new vec3(w, w, x);
  vec3 get wwy() => new vec3(w, w, y);
  vec3 get wwz() => new vec3(w, w, z);
  vec3 get www() => new vec3(w, w, w);
  vec4 get xxxx() => new vec4(x, x, x, x);
  vec4 get xxxy() => new vec4(x, x, x, y);
  vec4 get xxxz() => new vec4(x, x, x, z);
  vec4 get xxxw() => new vec4(x, x, x, w);
  vec4 get xxyx() => new vec4(x, x, y, x);
  vec4 get xxyy() => new vec4(x, x, y, y);
  vec4 get xxyz() => new vec4(x, x, y, z);
  vec4 get xxyw() => new vec4(x, x, y, w);
  vec4 get xxzx() => new vec4(x, x, z, x);
  vec4 get xxzy() => new vec4(x, x, z, y);
  vec4 get xxzz() => new vec4(x, x, z, z);
  vec4 get xxzw() => new vec4(x, x, z, w);
  vec4 get xxwx() => new vec4(x, x, w, x);
  vec4 get xxwy() => new vec4(x, x, w, y);
  vec4 get xxwz() => new vec4(x, x, w, z);
  vec4 get xxww() => new vec4(x, x, w, w);
  vec4 get xyxx() => new vec4(x, y, x, x);
  vec4 get xyxy() => new vec4(x, y, x, y);
  vec4 get xyxz() => new vec4(x, y, x, z);
  vec4 get xyxw() => new vec4(x, y, x, w);
  vec4 get xyyx() => new vec4(x, y, y, x);
  vec4 get xyyy() => new vec4(x, y, y, y);
  vec4 get xyyz() => new vec4(x, y, y, z);
  vec4 get xyyw() => new vec4(x, y, y, w);
  vec4 get xyzx() => new vec4(x, y, z, x);
  vec4 get xyzy() => new vec4(x, y, z, y);
  vec4 get xyzz() => new vec4(x, y, z, z);
  vec4 get xyzw() => new vec4(x, y, z, w);
  vec4 get xywx() => new vec4(x, y, w, x);
  vec4 get xywy() => new vec4(x, y, w, y);
  vec4 get xywz() => new vec4(x, y, w, z);
  vec4 get xyww() => new vec4(x, y, w, w);
  vec4 get xzxx() => new vec4(x, z, x, x);
  vec4 get xzxy() => new vec4(x, z, x, y);
  vec4 get xzxz() => new vec4(x, z, x, z);
  vec4 get xzxw() => new vec4(x, z, x, w);
  vec4 get xzyx() => new vec4(x, z, y, x);
  vec4 get xzyy() => new vec4(x, z, y, y);
  vec4 get xzyz() => new vec4(x, z, y, z);
  vec4 get xzyw() => new vec4(x, z, y, w);
  vec4 get xzzx() => new vec4(x, z, z, x);
  vec4 get xzzy() => new vec4(x, z, z, y);
  vec4 get xzzz() => new vec4(x, z, z, z);
  vec4 get xzzw() => new vec4(x, z, z, w);
  vec4 get xzwx() => new vec4(x, z, w, x);
  vec4 get xzwy() => new vec4(x, z, w, y);
  vec4 get xzwz() => new vec4(x, z, w, z);
  vec4 get xzww() => new vec4(x, z, w, w);
  vec4 get xwxx() => new vec4(x, w, x, x);
  vec4 get xwxy() => new vec4(x, w, x, y);
  vec4 get xwxz() => new vec4(x, w, x, z);
  vec4 get xwxw() => new vec4(x, w, x, w);
  vec4 get xwyx() => new vec4(x, w, y, x);
  vec4 get xwyy() => new vec4(x, w, y, y);
  vec4 get xwyz() => new vec4(x, w, y, z);
  vec4 get xwyw() => new vec4(x, w, y, w);
  vec4 get xwzx() => new vec4(x, w, z, x);
  vec4 get xwzy() => new vec4(x, w, z, y);
  vec4 get xwzz() => new vec4(x, w, z, z);
  vec4 get xwzw() => new vec4(x, w, z, w);
  vec4 get xwwx() => new vec4(x, w, w, x);
  vec4 get xwwy() => new vec4(x, w, w, y);
  vec4 get xwwz() => new vec4(x, w, w, z);
  vec4 get xwww() => new vec4(x, w, w, w);
  vec4 get yxxx() => new vec4(y, x, x, x);
  vec4 get yxxy() => new vec4(y, x, x, y);
  vec4 get yxxz() => new vec4(y, x, x, z);
  vec4 get yxxw() => new vec4(y, x, x, w);
  vec4 get yxyx() => new vec4(y, x, y, x);
  vec4 get yxyy() => new vec4(y, x, y, y);
  vec4 get yxyz() => new vec4(y, x, y, z);
  vec4 get yxyw() => new vec4(y, x, y, w);
  vec4 get yxzx() => new vec4(y, x, z, x);
  vec4 get yxzy() => new vec4(y, x, z, y);
  vec4 get yxzz() => new vec4(y, x, z, z);
  vec4 get yxzw() => new vec4(y, x, z, w);
  vec4 get yxwx() => new vec4(y, x, w, x);
  vec4 get yxwy() => new vec4(y, x, w, y);
  vec4 get yxwz() => new vec4(y, x, w, z);
  vec4 get yxww() => new vec4(y, x, w, w);
  vec4 get yyxx() => new vec4(y, y, x, x);
  vec4 get yyxy() => new vec4(y, y, x, y);
  vec4 get yyxz() => new vec4(y, y, x, z);
  vec4 get yyxw() => new vec4(y, y, x, w);
  vec4 get yyyx() => new vec4(y, y, y, x);
  vec4 get yyyy() => new vec4(y, y, y, y);
  vec4 get yyyz() => new vec4(y, y, y, z);
  vec4 get yyyw() => new vec4(y, y, y, w);
  vec4 get yyzx() => new vec4(y, y, z, x);
  vec4 get yyzy() => new vec4(y, y, z, y);
  vec4 get yyzz() => new vec4(y, y, z, z);
  vec4 get yyzw() => new vec4(y, y, z, w);
  vec4 get yywx() => new vec4(y, y, w, x);
  vec4 get yywy() => new vec4(y, y, w, y);
  vec4 get yywz() => new vec4(y, y, w, z);
  vec4 get yyww() => new vec4(y, y, w, w);
  vec4 get yzxx() => new vec4(y, z, x, x);
  vec4 get yzxy() => new vec4(y, z, x, y);
  vec4 get yzxz() => new vec4(y, z, x, z);
  vec4 get yzxw() => new vec4(y, z, x, w);
  vec4 get yzyx() => new vec4(y, z, y, x);
  vec4 get yzyy() => new vec4(y, z, y, y);
  vec4 get yzyz() => new vec4(y, z, y, z);
  vec4 get yzyw() => new vec4(y, z, y, w);
  vec4 get yzzx() => new vec4(y, z, z, x);
  vec4 get yzzy() => new vec4(y, z, z, y);
  vec4 get yzzz() => new vec4(y, z, z, z);
  vec4 get yzzw() => new vec4(y, z, z, w);
  vec4 get yzwx() => new vec4(y, z, w, x);
  vec4 get yzwy() => new vec4(y, z, w, y);
  vec4 get yzwz() => new vec4(y, z, w, z);
  vec4 get yzww() => new vec4(y, z, w, w);
  vec4 get ywxx() => new vec4(y, w, x, x);
  vec4 get ywxy() => new vec4(y, w, x, y);
  vec4 get ywxz() => new vec4(y, w, x, z);
  vec4 get ywxw() => new vec4(y, w, x, w);
  vec4 get ywyx() => new vec4(y, w, y, x);
  vec4 get ywyy() => new vec4(y, w, y, y);
  vec4 get ywyz() => new vec4(y, w, y, z);
  vec4 get ywyw() => new vec4(y, w, y, w);
  vec4 get ywzx() => new vec4(y, w, z, x);
  vec4 get ywzy() => new vec4(y, w, z, y);
  vec4 get ywzz() => new vec4(y, w, z, z);
  vec4 get ywzw() => new vec4(y, w, z, w);
  vec4 get ywwx() => new vec4(y, w, w, x);
  vec4 get ywwy() => new vec4(y, w, w, y);
  vec4 get ywwz() => new vec4(y, w, w, z);
  vec4 get ywww() => new vec4(y, w, w, w);
  vec4 get zxxx() => new vec4(z, x, x, x);
  vec4 get zxxy() => new vec4(z, x, x, y);
  vec4 get zxxz() => new vec4(z, x, x, z);
  vec4 get zxxw() => new vec4(z, x, x, w);
  vec4 get zxyx() => new vec4(z, x, y, x);
  vec4 get zxyy() => new vec4(z, x, y, y);
  vec4 get zxyz() => new vec4(z, x, y, z);
  vec4 get zxyw() => new vec4(z, x, y, w);
  vec4 get zxzx() => new vec4(z, x, z, x);
  vec4 get zxzy() => new vec4(z, x, z, y);
  vec4 get zxzz() => new vec4(z, x, z, z);
  vec4 get zxzw() => new vec4(z, x, z, w);
  vec4 get zxwx() => new vec4(z, x, w, x);
  vec4 get zxwy() => new vec4(z, x, w, y);
  vec4 get zxwz() => new vec4(z, x, w, z);
  vec4 get zxww() => new vec4(z, x, w, w);
  vec4 get zyxx() => new vec4(z, y, x, x);
  vec4 get zyxy() => new vec4(z, y, x, y);
  vec4 get zyxz() => new vec4(z, y, x, z);
  vec4 get zyxw() => new vec4(z, y, x, w);
  vec4 get zyyx() => new vec4(z, y, y, x);
  vec4 get zyyy() => new vec4(z, y, y, y);
  vec4 get zyyz() => new vec4(z, y, y, z);
  vec4 get zyyw() => new vec4(z, y, y, w);
  vec4 get zyzx() => new vec4(z, y, z, x);
  vec4 get zyzy() => new vec4(z, y, z, y);
  vec4 get zyzz() => new vec4(z, y, z, z);
  vec4 get zyzw() => new vec4(z, y, z, w);
  vec4 get zywx() => new vec4(z, y, w, x);
  vec4 get zywy() => new vec4(z, y, w, y);
  vec4 get zywz() => new vec4(z, y, w, z);
  vec4 get zyww() => new vec4(z, y, w, w);
  vec4 get zzxx() => new vec4(z, z, x, x);
  vec4 get zzxy() => new vec4(z, z, x, y);
  vec4 get zzxz() => new vec4(z, z, x, z);
  vec4 get zzxw() => new vec4(z, z, x, w);
  vec4 get zzyx() => new vec4(z, z, y, x);
  vec4 get zzyy() => new vec4(z, z, y, y);
  vec4 get zzyz() => new vec4(z, z, y, z);
  vec4 get zzyw() => new vec4(z, z, y, w);
  vec4 get zzzx() => new vec4(z, z, z, x);
  vec4 get zzzy() => new vec4(z, z, z, y);
  vec4 get zzzz() => new vec4(z, z, z, z);
  vec4 get zzzw() => new vec4(z, z, z, w);
  vec4 get zzwx() => new vec4(z, z, w, x);
  vec4 get zzwy() => new vec4(z, z, w, y);
  vec4 get zzwz() => new vec4(z, z, w, z);
  vec4 get zzww() => new vec4(z, z, w, w);
  vec4 get zwxx() => new vec4(z, w, x, x);
  vec4 get zwxy() => new vec4(z, w, x, y);
  vec4 get zwxz() => new vec4(z, w, x, z);
  vec4 get zwxw() => new vec4(z, w, x, w);
  vec4 get zwyx() => new vec4(z, w, y, x);
  vec4 get zwyy() => new vec4(z, w, y, y);
  vec4 get zwyz() => new vec4(z, w, y, z);
  vec4 get zwyw() => new vec4(z, w, y, w);
  vec4 get zwzx() => new vec4(z, w, z, x);
  vec4 get zwzy() => new vec4(z, w, z, y);
  vec4 get zwzz() => new vec4(z, w, z, z);
  vec4 get zwzw() => new vec4(z, w, z, w);
  vec4 get zwwx() => new vec4(z, w, w, x);
  vec4 get zwwy() => new vec4(z, w, w, y);
  vec4 get zwwz() => new vec4(z, w, w, z);
  vec4 get zwww() => new vec4(z, w, w, w);
  vec4 get wxxx() => new vec4(w, x, x, x);
  vec4 get wxxy() => new vec4(w, x, x, y);
  vec4 get wxxz() => new vec4(w, x, x, z);
  vec4 get wxxw() => new vec4(w, x, x, w);
  vec4 get wxyx() => new vec4(w, x, y, x);
  vec4 get wxyy() => new vec4(w, x, y, y);
  vec4 get wxyz() => new vec4(w, x, y, z);
  vec4 get wxyw() => new vec4(w, x, y, w);
  vec4 get wxzx() => new vec4(w, x, z, x);
  vec4 get wxzy() => new vec4(w, x, z, y);
  vec4 get wxzz() => new vec4(w, x, z, z);
  vec4 get wxzw() => new vec4(w, x, z, w);
  vec4 get wxwx() => new vec4(w, x, w, x);
  vec4 get wxwy() => new vec4(w, x, w, y);
  vec4 get wxwz() => new vec4(w, x, w, z);
  vec4 get wxww() => new vec4(w, x, w, w);
  vec4 get wyxx() => new vec4(w, y, x, x);
  vec4 get wyxy() => new vec4(w, y, x, y);
  vec4 get wyxz() => new vec4(w, y, x, z);
  vec4 get wyxw() => new vec4(w, y, x, w);
  vec4 get wyyx() => new vec4(w, y, y, x);
  vec4 get wyyy() => new vec4(w, y, y, y);
  vec4 get wyyz() => new vec4(w, y, y, z);
  vec4 get wyyw() => new vec4(w, y, y, w);
  vec4 get wyzx() => new vec4(w, y, z, x);
  vec4 get wyzy() => new vec4(w, y, z, y);
  vec4 get wyzz() => new vec4(w, y, z, z);
  vec4 get wyzw() => new vec4(w, y, z, w);
  vec4 get wywx() => new vec4(w, y, w, x);
  vec4 get wywy() => new vec4(w, y, w, y);
  vec4 get wywz() => new vec4(w, y, w, z);
  vec4 get wyww() => new vec4(w, y, w, w);
  vec4 get wzxx() => new vec4(w, z, x, x);
  vec4 get wzxy() => new vec4(w, z, x, y);
  vec4 get wzxz() => new vec4(w, z, x, z);
  vec4 get wzxw() => new vec4(w, z, x, w);
  vec4 get wzyx() => new vec4(w, z, y, x);
  vec4 get wzyy() => new vec4(w, z, y, y);
  vec4 get wzyz() => new vec4(w, z, y, z);
  vec4 get wzyw() => new vec4(w, z, y, w);
  vec4 get wzzx() => new vec4(w, z, z, x);
  vec4 get wzzy() => new vec4(w, z, z, y);
  vec4 get wzzz() => new vec4(w, z, z, z);
  vec4 get wzzw() => new vec4(w, z, z, w);
  vec4 get wzwx() => new vec4(w, z, w, x);
  vec4 get wzwy() => new vec4(w, z, w, y);
  vec4 get wzwz() => new vec4(w, z, w, z);
  vec4 get wzww() => new vec4(w, z, w, w);
  vec4 get wwxx() => new vec4(w, w, x, x);
  vec4 get wwxy() => new vec4(w, w, x, y);
  vec4 get wwxz() => new vec4(w, w, x, z);
  vec4 get wwxw() => new vec4(w, w, x, w);
  vec4 get wwyx() => new vec4(w, w, y, x);
  vec4 get wwyy() => new vec4(w, w, y, y);
  vec4 get wwyz() => new vec4(w, w, y, z);
  vec4 get wwyw() => new vec4(w, w, y, w);
  vec4 get wwzx() => new vec4(w, w, z, x);
  vec4 get wwzy() => new vec4(w, w, z, y);
  vec4 get wwzz() => new vec4(w, w, z, z);
  vec4 get wwzw() => new vec4(w, w, z, w);
  vec4 get wwwx() => new vec4(w, w, w, x);
  vec4 get wwwy() => new vec4(w, w, w, y);
  vec4 get wwwz() => new vec4(w, w, w, z);
  vec4 get wwww() => new vec4(w, w, w, w);
  num get r() => x;
  num get g() => y;
  num get b() => z;
  num get a() => w;
  num get s() => x;
  num get t() => y;
  num get p() => z;
  num get q() => w;
  vec2 get rr() => new vec2(r, r);
  vec2 get rg() => new vec2(r, g);
  vec2 get rb() => new vec2(r, b);
  vec2 get ra() => new vec2(r, a);
  vec2 get gr() => new vec2(g, r);
  vec2 get gg() => new vec2(g, g);
  vec2 get gb() => new vec2(g, b);
  vec2 get ga() => new vec2(g, a);
  vec2 get br() => new vec2(b, r);
  vec2 get bg() => new vec2(b, g);
  vec2 get bb() => new vec2(b, b);
  vec2 get ba() => new vec2(b, a);
  vec2 get ar() => new vec2(a, r);
  vec2 get ag() => new vec2(a, g);
  vec2 get ab() => new vec2(a, b);
  vec2 get aa() => new vec2(a, a);
  vec3 get rrr() => new vec3(r, r, r);
  vec3 get rrg() => new vec3(r, r, g);
  vec3 get rrb() => new vec3(r, r, b);
  vec3 get rra() => new vec3(r, r, a);
  vec3 get rgr() => new vec3(r, g, r);
  vec3 get rgg() => new vec3(r, g, g);
  vec3 get rgb() => new vec3(r, g, b);
  vec3 get rga() => new vec3(r, g, a);
  vec3 get rbr() => new vec3(r, b, r);
  vec3 get rbg() => new vec3(r, b, g);
  vec3 get rbb() => new vec3(r, b, b);
  vec3 get rba() => new vec3(r, b, a);
  vec3 get rar() => new vec3(r, a, r);
  vec3 get rag() => new vec3(r, a, g);
  vec3 get rab() => new vec3(r, a, b);
  vec3 get raa() => new vec3(r, a, a);
  vec3 get grr() => new vec3(g, r, r);
  vec3 get grg() => new vec3(g, r, g);
  vec3 get grb() => new vec3(g, r, b);
  vec3 get gra() => new vec3(g, r, a);
  vec3 get ggr() => new vec3(g, g, r);
  vec3 get ggg() => new vec3(g, g, g);
  vec3 get ggb() => new vec3(g, g, b);
  vec3 get gga() => new vec3(g, g, a);
  vec3 get gbr() => new vec3(g, b, r);
  vec3 get gbg() => new vec3(g, b, g);
  vec3 get gbb() => new vec3(g, b, b);
  vec3 get gba() => new vec3(g, b, a);
  vec3 get gar() => new vec3(g, a, r);
  vec3 get gag() => new vec3(g, a, g);
  vec3 get gab() => new vec3(g, a, b);
  vec3 get gaa() => new vec3(g, a, a);
  vec3 get brr() => new vec3(b, r, r);
  vec3 get brg() => new vec3(b, r, g);
  vec3 get brb() => new vec3(b, r, b);
  vec3 get bra() => new vec3(b, r, a);
  vec3 get bgr() => new vec3(b, g, r);
  vec3 get bgg() => new vec3(b, g, g);
  vec3 get bgb() => new vec3(b, g, b);
  vec3 get bga() => new vec3(b, g, a);
  vec3 get bbr() => new vec3(b, b, r);
  vec3 get bbg() => new vec3(b, b, g);
  vec3 get bbb() => new vec3(b, b, b);
  vec3 get bba() => new vec3(b, b, a);
  vec3 get bar() => new vec3(b, a, r);
  vec3 get bag() => new vec3(b, a, g);
  vec3 get bab() => new vec3(b, a, b);
  vec3 get baa() => new vec3(b, a, a);
  vec3 get arr() => new vec3(a, r, r);
  vec3 get arg() => new vec3(a, r, g);
  vec3 get arb() => new vec3(a, r, b);
  vec3 get ara() => new vec3(a, r, a);
  vec3 get agr() => new vec3(a, g, r);
  vec3 get agg() => new vec3(a, g, g);
  vec3 get agb() => new vec3(a, g, b);
  vec3 get aga() => new vec3(a, g, a);
  vec3 get abr() => new vec3(a, b, r);
  vec3 get abg() => new vec3(a, b, g);
  vec3 get abb() => new vec3(a, b, b);
  vec3 get aba() => new vec3(a, b, a);
  vec3 get aar() => new vec3(a, a, r);
  vec3 get aag() => new vec3(a, a, g);
  vec3 get aab() => new vec3(a, a, b);
  vec3 get aaa() => new vec3(a, a, a);
  vec4 get rrrr() => new vec4(r, r, r, r);
  vec4 get rrrg() => new vec4(r, r, r, g);
  vec4 get rrrb() => new vec4(r, r, r, b);
  vec4 get rrra() => new vec4(r, r, r, a);
  vec4 get rrgr() => new vec4(r, r, g, r);
  vec4 get rrgg() => new vec4(r, r, g, g);
  vec4 get rrgb() => new vec4(r, r, g, b);
  vec4 get rrga() => new vec4(r, r, g, a);
  vec4 get rrbr() => new vec4(r, r, b, r);
  vec4 get rrbg() => new vec4(r, r, b, g);
  vec4 get rrbb() => new vec4(r, r, b, b);
  vec4 get rrba() => new vec4(r, r, b, a);
  vec4 get rrar() => new vec4(r, r, a, r);
  vec4 get rrag() => new vec4(r, r, a, g);
  vec4 get rrab() => new vec4(r, r, a, b);
  vec4 get rraa() => new vec4(r, r, a, a);
  vec4 get rgrr() => new vec4(r, g, r, r);
  vec4 get rgrg() => new vec4(r, g, r, g);
  vec4 get rgrb() => new vec4(r, g, r, b);
  vec4 get rgra() => new vec4(r, g, r, a);
  vec4 get rggr() => new vec4(r, g, g, r);
  vec4 get rggg() => new vec4(r, g, g, g);
  vec4 get rggb() => new vec4(r, g, g, b);
  vec4 get rgga() => new vec4(r, g, g, a);
  vec4 get rgbr() => new vec4(r, g, b, r);
  vec4 get rgbg() => new vec4(r, g, b, g);
  vec4 get rgbb() => new vec4(r, g, b, b);
  vec4 get rgba() => new vec4(r, g, b, a);
  vec4 get rgar() => new vec4(r, g, a, r);
  vec4 get rgag() => new vec4(r, g, a, g);
  vec4 get rgab() => new vec4(r, g, a, b);
  vec4 get rgaa() => new vec4(r, g, a, a);
  vec4 get rbrr() => new vec4(r, b, r, r);
  vec4 get rbrg() => new vec4(r, b, r, g);
  vec4 get rbrb() => new vec4(r, b, r, b);
  vec4 get rbra() => new vec4(r, b, r, a);
  vec4 get rbgr() => new vec4(r, b, g, r);
  vec4 get rbgg() => new vec4(r, b, g, g);
  vec4 get rbgb() => new vec4(r, b, g, b);
  vec4 get rbga() => new vec4(r, b, g, a);
  vec4 get rbbr() => new vec4(r, b, b, r);
  vec4 get rbbg() => new vec4(r, b, b, g);
  vec4 get rbbb() => new vec4(r, b, b, b);
  vec4 get rbba() => new vec4(r, b, b, a);
  vec4 get rbar() => new vec4(r, b, a, r);
  vec4 get rbag() => new vec4(r, b, a, g);
  vec4 get rbab() => new vec4(r, b, a, b);
  vec4 get rbaa() => new vec4(r, b, a, a);
  vec4 get rarr() => new vec4(r, a, r, r);
  vec4 get rarg() => new vec4(r, a, r, g);
  vec4 get rarb() => new vec4(r, a, r, b);
  vec4 get rara() => new vec4(r, a, r, a);
  vec4 get ragr() => new vec4(r, a, g, r);
  vec4 get ragg() => new vec4(r, a, g, g);
  vec4 get ragb() => new vec4(r, a, g, b);
  vec4 get raga() => new vec4(r, a, g, a);
  vec4 get rabr() => new vec4(r, a, b, r);
  vec4 get rabg() => new vec4(r, a, b, g);
  vec4 get rabb() => new vec4(r, a, b, b);
  vec4 get raba() => new vec4(r, a, b, a);
  vec4 get raar() => new vec4(r, a, a, r);
  vec4 get raag() => new vec4(r, a, a, g);
  vec4 get raab() => new vec4(r, a, a, b);
  vec4 get raaa() => new vec4(r, a, a, a);
  vec4 get grrr() => new vec4(g, r, r, r);
  vec4 get grrg() => new vec4(g, r, r, g);
  vec4 get grrb() => new vec4(g, r, r, b);
  vec4 get grra() => new vec4(g, r, r, a);
  vec4 get grgr() => new vec4(g, r, g, r);
  vec4 get grgg() => new vec4(g, r, g, g);
  vec4 get grgb() => new vec4(g, r, g, b);
  vec4 get grga() => new vec4(g, r, g, a);
  vec4 get grbr() => new vec4(g, r, b, r);
  vec4 get grbg() => new vec4(g, r, b, g);
  vec4 get grbb() => new vec4(g, r, b, b);
  vec4 get grba() => new vec4(g, r, b, a);
  vec4 get grar() => new vec4(g, r, a, r);
  vec4 get grag() => new vec4(g, r, a, g);
  vec4 get grab() => new vec4(g, r, a, b);
  vec4 get graa() => new vec4(g, r, a, a);
  vec4 get ggrr() => new vec4(g, g, r, r);
  vec4 get ggrg() => new vec4(g, g, r, g);
  vec4 get ggrb() => new vec4(g, g, r, b);
  vec4 get ggra() => new vec4(g, g, r, a);
  vec4 get gggr() => new vec4(g, g, g, r);
  vec4 get gggg() => new vec4(g, g, g, g);
  vec4 get gggb() => new vec4(g, g, g, b);
  vec4 get ggga() => new vec4(g, g, g, a);
  vec4 get ggbr() => new vec4(g, g, b, r);
  vec4 get ggbg() => new vec4(g, g, b, g);
  vec4 get ggbb() => new vec4(g, g, b, b);
  vec4 get ggba() => new vec4(g, g, b, a);
  vec4 get ggar() => new vec4(g, g, a, r);
  vec4 get ggag() => new vec4(g, g, a, g);
  vec4 get ggab() => new vec4(g, g, a, b);
  vec4 get ggaa() => new vec4(g, g, a, a);
  vec4 get gbrr() => new vec4(g, b, r, r);
  vec4 get gbrg() => new vec4(g, b, r, g);
  vec4 get gbrb() => new vec4(g, b, r, b);
  vec4 get gbra() => new vec4(g, b, r, a);
  vec4 get gbgr() => new vec4(g, b, g, r);
  vec4 get gbgg() => new vec4(g, b, g, g);
  vec4 get gbgb() => new vec4(g, b, g, b);
  vec4 get gbga() => new vec4(g, b, g, a);
  vec4 get gbbr() => new vec4(g, b, b, r);
  vec4 get gbbg() => new vec4(g, b, b, g);
  vec4 get gbbb() => new vec4(g, b, b, b);
  vec4 get gbba() => new vec4(g, b, b, a);
  vec4 get gbar() => new vec4(g, b, a, r);
  vec4 get gbag() => new vec4(g, b, a, g);
  vec4 get gbab() => new vec4(g, b, a, b);
  vec4 get gbaa() => new vec4(g, b, a, a);
  vec4 get garr() => new vec4(g, a, r, r);
  vec4 get garg() => new vec4(g, a, r, g);
  vec4 get garb() => new vec4(g, a, r, b);
  vec4 get gara() => new vec4(g, a, r, a);
  vec4 get gagr() => new vec4(g, a, g, r);
  vec4 get gagg() => new vec4(g, a, g, g);
  vec4 get gagb() => new vec4(g, a, g, b);
  vec4 get gaga() => new vec4(g, a, g, a);
  vec4 get gabr() => new vec4(g, a, b, r);
  vec4 get gabg() => new vec4(g, a, b, g);
  vec4 get gabb() => new vec4(g, a, b, b);
  vec4 get gaba() => new vec4(g, a, b, a);
  vec4 get gaar() => new vec4(g, a, a, r);
  vec4 get gaag() => new vec4(g, a, a, g);
  vec4 get gaab() => new vec4(g, a, a, b);
  vec4 get gaaa() => new vec4(g, a, a, a);
  vec4 get brrr() => new vec4(b, r, r, r);
  vec4 get brrg() => new vec4(b, r, r, g);
  vec4 get brrb() => new vec4(b, r, r, b);
  vec4 get brra() => new vec4(b, r, r, a);
  vec4 get brgr() => new vec4(b, r, g, r);
  vec4 get brgg() => new vec4(b, r, g, g);
  vec4 get brgb() => new vec4(b, r, g, b);
  vec4 get brga() => new vec4(b, r, g, a);
  vec4 get brbr() => new vec4(b, r, b, r);
  vec4 get brbg() => new vec4(b, r, b, g);
  vec4 get brbb() => new vec4(b, r, b, b);
  vec4 get brba() => new vec4(b, r, b, a);
  vec4 get brar() => new vec4(b, r, a, r);
  vec4 get brag() => new vec4(b, r, a, g);
  vec4 get brab() => new vec4(b, r, a, b);
  vec4 get braa() => new vec4(b, r, a, a);
  vec4 get bgrr() => new vec4(b, g, r, r);
  vec4 get bgrg() => new vec4(b, g, r, g);
  vec4 get bgrb() => new vec4(b, g, r, b);
  vec4 get bgra() => new vec4(b, g, r, a);
  vec4 get bggr() => new vec4(b, g, g, r);
  vec4 get bggg() => new vec4(b, g, g, g);
  vec4 get bggb() => new vec4(b, g, g, b);
  vec4 get bgga() => new vec4(b, g, g, a);
  vec4 get bgbr() => new vec4(b, g, b, r);
  vec4 get bgbg() => new vec4(b, g, b, g);
  vec4 get bgbb() => new vec4(b, g, b, b);
  vec4 get bgba() => new vec4(b, g, b, a);
  vec4 get bgar() => new vec4(b, g, a, r);
  vec4 get bgag() => new vec4(b, g, a, g);
  vec4 get bgab() => new vec4(b, g, a, b);
  vec4 get bgaa() => new vec4(b, g, a, a);
  vec4 get bbrr() => new vec4(b, b, r, r);
  vec4 get bbrg() => new vec4(b, b, r, g);
  vec4 get bbrb() => new vec4(b, b, r, b);
  vec4 get bbra() => new vec4(b, b, r, a);
  vec4 get bbgr() => new vec4(b, b, g, r);
  vec4 get bbgg() => new vec4(b, b, g, g);
  vec4 get bbgb() => new vec4(b, b, g, b);
  vec4 get bbga() => new vec4(b, b, g, a);
  vec4 get bbbr() => new vec4(b, b, b, r);
  vec4 get bbbg() => new vec4(b, b, b, g);
  vec4 get bbbb() => new vec4(b, b, b, b);
  vec4 get bbba() => new vec4(b, b, b, a);
  vec4 get bbar() => new vec4(b, b, a, r);
  vec4 get bbag() => new vec4(b, b, a, g);
  vec4 get bbab() => new vec4(b, b, a, b);
  vec4 get bbaa() => new vec4(b, b, a, a);
  vec4 get barr() => new vec4(b, a, r, r);
  vec4 get barg() => new vec4(b, a, r, g);
  vec4 get barb() => new vec4(b, a, r, b);
  vec4 get bara() => new vec4(b, a, r, a);
  vec4 get bagr() => new vec4(b, a, g, r);
  vec4 get bagg() => new vec4(b, a, g, g);
  vec4 get bagb() => new vec4(b, a, g, b);
  vec4 get baga() => new vec4(b, a, g, a);
  vec4 get babr() => new vec4(b, a, b, r);
  vec4 get babg() => new vec4(b, a, b, g);
  vec4 get babb() => new vec4(b, a, b, b);
  vec4 get baba() => new vec4(b, a, b, a);
  vec4 get baar() => new vec4(b, a, a, r);
  vec4 get baag() => new vec4(b, a, a, g);
  vec4 get baab() => new vec4(b, a, a, b);
  vec4 get baaa() => new vec4(b, a, a, a);
  vec4 get arrr() => new vec4(a, r, r, r);
  vec4 get arrg() => new vec4(a, r, r, g);
  vec4 get arrb() => new vec4(a, r, r, b);
  vec4 get arra() => new vec4(a, r, r, a);
  vec4 get argr() => new vec4(a, r, g, r);
  vec4 get argg() => new vec4(a, r, g, g);
  vec4 get argb() => new vec4(a, r, g, b);
  vec4 get arga() => new vec4(a, r, g, a);
  vec4 get arbr() => new vec4(a, r, b, r);
  vec4 get arbg() => new vec4(a, r, b, g);
  vec4 get arbb() => new vec4(a, r, b, b);
  vec4 get arba() => new vec4(a, r, b, a);
  vec4 get arar() => new vec4(a, r, a, r);
  vec4 get arag() => new vec4(a, r, a, g);
  vec4 get arab() => new vec4(a, r, a, b);
  vec4 get araa() => new vec4(a, r, a, a);
  vec4 get agrr() => new vec4(a, g, r, r);
  vec4 get agrg() => new vec4(a, g, r, g);
  vec4 get agrb() => new vec4(a, g, r, b);
  vec4 get agra() => new vec4(a, g, r, a);
  vec4 get aggr() => new vec4(a, g, g, r);
  vec4 get aggg() => new vec4(a, g, g, g);
  vec4 get aggb() => new vec4(a, g, g, b);
  vec4 get agga() => new vec4(a, g, g, a);
  vec4 get agbr() => new vec4(a, g, b, r);
  vec4 get agbg() => new vec4(a, g, b, g);
  vec4 get agbb() => new vec4(a, g, b, b);
  vec4 get agba() => new vec4(a, g, b, a);
  vec4 get agar() => new vec4(a, g, a, r);
  vec4 get agag() => new vec4(a, g, a, g);
  vec4 get agab() => new vec4(a, g, a, b);
  vec4 get agaa() => new vec4(a, g, a, a);
  vec4 get abrr() => new vec4(a, b, r, r);
  vec4 get abrg() => new vec4(a, b, r, g);
  vec4 get abrb() => new vec4(a, b, r, b);
  vec4 get abra() => new vec4(a, b, r, a);
  vec4 get abgr() => new vec4(a, b, g, r);
  vec4 get abgg() => new vec4(a, b, g, g);
  vec4 get abgb() => new vec4(a, b, g, b);
  vec4 get abga() => new vec4(a, b, g, a);
  vec4 get abbr() => new vec4(a, b, b, r);
  vec4 get abbg() => new vec4(a, b, b, g);
  vec4 get abbb() => new vec4(a, b, b, b);
  vec4 get abba() => new vec4(a, b, b, a);
  vec4 get abar() => new vec4(a, b, a, r);
  vec4 get abag() => new vec4(a, b, a, g);
  vec4 get abab() => new vec4(a, b, a, b);
  vec4 get abaa() => new vec4(a, b, a, a);
  vec4 get aarr() => new vec4(a, a, r, r);
  vec4 get aarg() => new vec4(a, a, r, g);
  vec4 get aarb() => new vec4(a, a, r, b);
  vec4 get aara() => new vec4(a, a, r, a);
  vec4 get aagr() => new vec4(a, a, g, r);
  vec4 get aagg() => new vec4(a, a, g, g);
  vec4 get aagb() => new vec4(a, a, g, b);
  vec4 get aaga() => new vec4(a, a, g, a);
  vec4 get aabr() => new vec4(a, a, b, r);
  vec4 get aabg() => new vec4(a, a, b, g);
  vec4 get aabb() => new vec4(a, a, b, b);
  vec4 get aaba() => new vec4(a, a, b, a);
  vec4 get aaar() => new vec4(a, a, a, r);
  vec4 get aaag() => new vec4(a, a, a, g);
  vec4 get aaab() => new vec4(a, a, a, b);
  vec4 get aaaa() => new vec4(a, a, a, a);
  vec2 get ss() => new vec2(s, s);
  vec2 get st() => new vec2(s, t);
  vec2 get sp() => new vec2(s, p);
  vec2 get sq() => new vec2(s, q);
  vec2 get ts() => new vec2(t, s);
  vec2 get tt() => new vec2(t, t);
  vec2 get tp() => new vec2(t, p);
  vec2 get tq() => new vec2(t, q);
  vec2 get ps() => new vec2(p, s);
  vec2 get pt() => new vec2(p, t);
  vec2 get pp() => new vec2(p, p);
  vec2 get pq() => new vec2(p, q);
  vec2 get qs() => new vec2(q, s);
  vec2 get qt() => new vec2(q, t);
  vec2 get qp() => new vec2(q, p);
  vec2 get qq() => new vec2(q, q);
  vec3 get sss() => new vec3(s, s, s);
  vec3 get sst() => new vec3(s, s, t);
  vec3 get ssp() => new vec3(s, s, p);
  vec3 get ssq() => new vec3(s, s, q);
  vec3 get sts() => new vec3(s, t, s);
  vec3 get stt() => new vec3(s, t, t);
  vec3 get stp() => new vec3(s, t, p);
  vec3 get stq() => new vec3(s, t, q);
  vec3 get sps() => new vec3(s, p, s);
  vec3 get spt() => new vec3(s, p, t);
  vec3 get spp() => new vec3(s, p, p);
  vec3 get spq() => new vec3(s, p, q);
  vec3 get sqs() => new vec3(s, q, s);
  vec3 get sqt() => new vec3(s, q, t);
  vec3 get sqp() => new vec3(s, q, p);
  vec3 get sqq() => new vec3(s, q, q);
  vec3 get tss() => new vec3(t, s, s);
  vec3 get tst() => new vec3(t, s, t);
  vec3 get tsp() => new vec3(t, s, p);
  vec3 get tsq() => new vec3(t, s, q);
  vec3 get tts() => new vec3(t, t, s);
  vec3 get ttt() => new vec3(t, t, t);
  vec3 get ttp() => new vec3(t, t, p);
  vec3 get ttq() => new vec3(t, t, q);
  vec3 get tps() => new vec3(t, p, s);
  vec3 get tpt() => new vec3(t, p, t);
  vec3 get tpp() => new vec3(t, p, p);
  vec3 get tpq() => new vec3(t, p, q);
  vec3 get tqs() => new vec3(t, q, s);
  vec3 get tqt() => new vec3(t, q, t);
  vec3 get tqp() => new vec3(t, q, p);
  vec3 get tqq() => new vec3(t, q, q);
  vec3 get pss() => new vec3(p, s, s);
  vec3 get pst() => new vec3(p, s, t);
  vec3 get psp() => new vec3(p, s, p);
  vec3 get psq() => new vec3(p, s, q);
  vec3 get pts() => new vec3(p, t, s);
  vec3 get ptt() => new vec3(p, t, t);
  vec3 get ptp() => new vec3(p, t, p);
  vec3 get ptq() => new vec3(p, t, q);
  vec3 get pps() => new vec3(p, p, s);
  vec3 get ppt() => new vec3(p, p, t);
  vec3 get ppp() => new vec3(p, p, p);
  vec3 get ppq() => new vec3(p, p, q);
  vec3 get pqs() => new vec3(p, q, s);
  vec3 get pqt() => new vec3(p, q, t);
  vec3 get pqp() => new vec3(p, q, p);
  vec3 get pqq() => new vec3(p, q, q);
  vec3 get qss() => new vec3(q, s, s);
  vec3 get qst() => new vec3(q, s, t);
  vec3 get qsp() => new vec3(q, s, p);
  vec3 get qsq() => new vec3(q, s, q);
  vec3 get qts() => new vec3(q, t, s);
  vec3 get qtt() => new vec3(q, t, t);
  vec3 get qtp() => new vec3(q, t, p);
  vec3 get qtq() => new vec3(q, t, q);
  vec3 get qps() => new vec3(q, p, s);
  vec3 get qpt() => new vec3(q, p, t);
  vec3 get qpp() => new vec3(q, p, p);
  vec3 get qpq() => new vec3(q, p, q);
  vec3 get qqs() => new vec3(q, q, s);
  vec3 get qqt() => new vec3(q, q, t);
  vec3 get qqp() => new vec3(q, q, p);
  vec3 get qqq() => new vec3(q, q, q);
  vec4 get ssss() => new vec4(s, s, s, s);
  vec4 get ssst() => new vec4(s, s, s, t);
  vec4 get sssp() => new vec4(s, s, s, p);
  vec4 get sssq() => new vec4(s, s, s, q);
  vec4 get ssts() => new vec4(s, s, t, s);
  vec4 get sstt() => new vec4(s, s, t, t);
  vec4 get sstp() => new vec4(s, s, t, p);
  vec4 get sstq() => new vec4(s, s, t, q);
  vec4 get ssps() => new vec4(s, s, p, s);
  vec4 get sspt() => new vec4(s, s, p, t);
  vec4 get sspp() => new vec4(s, s, p, p);
  vec4 get sspq() => new vec4(s, s, p, q);
  vec4 get ssqs() => new vec4(s, s, q, s);
  vec4 get ssqt() => new vec4(s, s, q, t);
  vec4 get ssqp() => new vec4(s, s, q, p);
  vec4 get ssqq() => new vec4(s, s, q, q);
  vec4 get stss() => new vec4(s, t, s, s);
  vec4 get stst() => new vec4(s, t, s, t);
  vec4 get stsp() => new vec4(s, t, s, p);
  vec4 get stsq() => new vec4(s, t, s, q);
  vec4 get stts() => new vec4(s, t, t, s);
  vec4 get sttt() => new vec4(s, t, t, t);
  vec4 get sttp() => new vec4(s, t, t, p);
  vec4 get sttq() => new vec4(s, t, t, q);
  vec4 get stps() => new vec4(s, t, p, s);
  vec4 get stpt() => new vec4(s, t, p, t);
  vec4 get stpp() => new vec4(s, t, p, p);
  vec4 get stpq() => new vec4(s, t, p, q);
  vec4 get stqs() => new vec4(s, t, q, s);
  vec4 get stqt() => new vec4(s, t, q, t);
  vec4 get stqp() => new vec4(s, t, q, p);
  vec4 get stqq() => new vec4(s, t, q, q);
  vec4 get spss() => new vec4(s, p, s, s);
  vec4 get spst() => new vec4(s, p, s, t);
  vec4 get spsp() => new vec4(s, p, s, p);
  vec4 get spsq() => new vec4(s, p, s, q);
  vec4 get spts() => new vec4(s, p, t, s);
  vec4 get sptt() => new vec4(s, p, t, t);
  vec4 get sptp() => new vec4(s, p, t, p);
  vec4 get sptq() => new vec4(s, p, t, q);
  vec4 get spps() => new vec4(s, p, p, s);
  vec4 get sppt() => new vec4(s, p, p, t);
  vec4 get sppp() => new vec4(s, p, p, p);
  vec4 get sppq() => new vec4(s, p, p, q);
  vec4 get spqs() => new vec4(s, p, q, s);
  vec4 get spqt() => new vec4(s, p, q, t);
  vec4 get spqp() => new vec4(s, p, q, p);
  vec4 get spqq() => new vec4(s, p, q, q);
  vec4 get sqss() => new vec4(s, q, s, s);
  vec4 get sqst() => new vec4(s, q, s, t);
  vec4 get sqsp() => new vec4(s, q, s, p);
  vec4 get sqsq() => new vec4(s, q, s, q);
  vec4 get sqts() => new vec4(s, q, t, s);
  vec4 get sqtt() => new vec4(s, q, t, t);
  vec4 get sqtp() => new vec4(s, q, t, p);
  vec4 get sqtq() => new vec4(s, q, t, q);
  vec4 get sqps() => new vec4(s, q, p, s);
  vec4 get sqpt() => new vec4(s, q, p, t);
  vec4 get sqpp() => new vec4(s, q, p, p);
  vec4 get sqpq() => new vec4(s, q, p, q);
  vec4 get sqqs() => new vec4(s, q, q, s);
  vec4 get sqqt() => new vec4(s, q, q, t);
  vec4 get sqqp() => new vec4(s, q, q, p);
  vec4 get sqqq() => new vec4(s, q, q, q);
  vec4 get tsss() => new vec4(t, s, s, s);
  vec4 get tsst() => new vec4(t, s, s, t);
  vec4 get tssp() => new vec4(t, s, s, p);
  vec4 get tssq() => new vec4(t, s, s, q);
  vec4 get tsts() => new vec4(t, s, t, s);
  vec4 get tstt() => new vec4(t, s, t, t);
  vec4 get tstp() => new vec4(t, s, t, p);
  vec4 get tstq() => new vec4(t, s, t, q);
  vec4 get tsps() => new vec4(t, s, p, s);
  vec4 get tspt() => new vec4(t, s, p, t);
  vec4 get tspp() => new vec4(t, s, p, p);
  vec4 get tspq() => new vec4(t, s, p, q);
  vec4 get tsqs() => new vec4(t, s, q, s);
  vec4 get tsqt() => new vec4(t, s, q, t);
  vec4 get tsqp() => new vec4(t, s, q, p);
  vec4 get tsqq() => new vec4(t, s, q, q);
  vec4 get ttss() => new vec4(t, t, s, s);
  vec4 get ttst() => new vec4(t, t, s, t);
  vec4 get ttsp() => new vec4(t, t, s, p);
  vec4 get ttsq() => new vec4(t, t, s, q);
  vec4 get ttts() => new vec4(t, t, t, s);
  vec4 get tttt() => new vec4(t, t, t, t);
  vec4 get tttp() => new vec4(t, t, t, p);
  vec4 get tttq() => new vec4(t, t, t, q);
  vec4 get ttps() => new vec4(t, t, p, s);
  vec4 get ttpt() => new vec4(t, t, p, t);
  vec4 get ttpp() => new vec4(t, t, p, p);
  vec4 get ttpq() => new vec4(t, t, p, q);
  vec4 get ttqs() => new vec4(t, t, q, s);
  vec4 get ttqt() => new vec4(t, t, q, t);
  vec4 get ttqp() => new vec4(t, t, q, p);
  vec4 get ttqq() => new vec4(t, t, q, q);
  vec4 get tpss() => new vec4(t, p, s, s);
  vec4 get tpst() => new vec4(t, p, s, t);
  vec4 get tpsp() => new vec4(t, p, s, p);
  vec4 get tpsq() => new vec4(t, p, s, q);
  vec4 get tpts() => new vec4(t, p, t, s);
  vec4 get tptt() => new vec4(t, p, t, t);
  vec4 get tptp() => new vec4(t, p, t, p);
  vec4 get tptq() => new vec4(t, p, t, q);
  vec4 get tpps() => new vec4(t, p, p, s);
  vec4 get tppt() => new vec4(t, p, p, t);
  vec4 get tppp() => new vec4(t, p, p, p);
  vec4 get tppq() => new vec4(t, p, p, q);
  vec4 get tpqs() => new vec4(t, p, q, s);
  vec4 get tpqt() => new vec4(t, p, q, t);
  vec4 get tpqp() => new vec4(t, p, q, p);
  vec4 get tpqq() => new vec4(t, p, q, q);
  vec4 get tqss() => new vec4(t, q, s, s);
  vec4 get tqst() => new vec4(t, q, s, t);
  vec4 get tqsp() => new vec4(t, q, s, p);
  vec4 get tqsq() => new vec4(t, q, s, q);
  vec4 get tqts() => new vec4(t, q, t, s);
  vec4 get tqtt() => new vec4(t, q, t, t);
  vec4 get tqtp() => new vec4(t, q, t, p);
  vec4 get tqtq() => new vec4(t, q, t, q);
  vec4 get tqps() => new vec4(t, q, p, s);
  vec4 get tqpt() => new vec4(t, q, p, t);
  vec4 get tqpp() => new vec4(t, q, p, p);
  vec4 get tqpq() => new vec4(t, q, p, q);
  vec4 get tqqs() => new vec4(t, q, q, s);
  vec4 get tqqt() => new vec4(t, q, q, t);
  vec4 get tqqp() => new vec4(t, q, q, p);
  vec4 get tqqq() => new vec4(t, q, q, q);
  vec4 get psss() => new vec4(p, s, s, s);
  vec4 get psst() => new vec4(p, s, s, t);
  vec4 get pssp() => new vec4(p, s, s, p);
  vec4 get pssq() => new vec4(p, s, s, q);
  vec4 get psts() => new vec4(p, s, t, s);
  vec4 get pstt() => new vec4(p, s, t, t);
  vec4 get pstp() => new vec4(p, s, t, p);
  vec4 get pstq() => new vec4(p, s, t, q);
  vec4 get psps() => new vec4(p, s, p, s);
  vec4 get pspt() => new vec4(p, s, p, t);
  vec4 get pspp() => new vec4(p, s, p, p);
  vec4 get pspq() => new vec4(p, s, p, q);
  vec4 get psqs() => new vec4(p, s, q, s);
  vec4 get psqt() => new vec4(p, s, q, t);
  vec4 get psqp() => new vec4(p, s, q, p);
  vec4 get psqq() => new vec4(p, s, q, q);
  vec4 get ptss() => new vec4(p, t, s, s);
  vec4 get ptst() => new vec4(p, t, s, t);
  vec4 get ptsp() => new vec4(p, t, s, p);
  vec4 get ptsq() => new vec4(p, t, s, q);
  vec4 get ptts() => new vec4(p, t, t, s);
  vec4 get pttt() => new vec4(p, t, t, t);
  vec4 get pttp() => new vec4(p, t, t, p);
  vec4 get pttq() => new vec4(p, t, t, q);
  vec4 get ptps() => new vec4(p, t, p, s);
  vec4 get ptpt() => new vec4(p, t, p, t);
  vec4 get ptpp() => new vec4(p, t, p, p);
  vec4 get ptpq() => new vec4(p, t, p, q);
  vec4 get ptqs() => new vec4(p, t, q, s);
  vec4 get ptqt() => new vec4(p, t, q, t);
  vec4 get ptqp() => new vec4(p, t, q, p);
  vec4 get ptqq() => new vec4(p, t, q, q);
  vec4 get ppss() => new vec4(p, p, s, s);
  vec4 get ppst() => new vec4(p, p, s, t);
  vec4 get ppsp() => new vec4(p, p, s, p);
  vec4 get ppsq() => new vec4(p, p, s, q);
  vec4 get ppts() => new vec4(p, p, t, s);
  vec4 get pptt() => new vec4(p, p, t, t);
  vec4 get pptp() => new vec4(p, p, t, p);
  vec4 get pptq() => new vec4(p, p, t, q);
  vec4 get ppps() => new vec4(p, p, p, s);
  vec4 get pppt() => new vec4(p, p, p, t);
  vec4 get pppp() => new vec4(p, p, p, p);
  vec4 get pppq() => new vec4(p, p, p, q);
  vec4 get ppqs() => new vec4(p, p, q, s);
  vec4 get ppqt() => new vec4(p, p, q, t);
  vec4 get ppqp() => new vec4(p, p, q, p);
  vec4 get ppqq() => new vec4(p, p, q, q);
  vec4 get pqss() => new vec4(p, q, s, s);
  vec4 get pqst() => new vec4(p, q, s, t);
  vec4 get pqsp() => new vec4(p, q, s, p);
  vec4 get pqsq() => new vec4(p, q, s, q);
  vec4 get pqts() => new vec4(p, q, t, s);
  vec4 get pqtt() => new vec4(p, q, t, t);
  vec4 get pqtp() => new vec4(p, q, t, p);
  vec4 get pqtq() => new vec4(p, q, t, q);
  vec4 get pqps() => new vec4(p, q, p, s);
  vec4 get pqpt() => new vec4(p, q, p, t);
  vec4 get pqpp() => new vec4(p, q, p, p);
  vec4 get pqpq() => new vec4(p, q, p, q);
  vec4 get pqqs() => new vec4(p, q, q, s);
  vec4 get pqqt() => new vec4(p, q, q, t);
  vec4 get pqqp() => new vec4(p, q, q, p);
  vec4 get pqqq() => new vec4(p, q, q, q);
  vec4 get qsss() => new vec4(q, s, s, s);
  vec4 get qsst() => new vec4(q, s, s, t);
  vec4 get qssp() => new vec4(q, s, s, p);
  vec4 get qssq() => new vec4(q, s, s, q);
  vec4 get qsts() => new vec4(q, s, t, s);
  vec4 get qstt() => new vec4(q, s, t, t);
  vec4 get qstp() => new vec4(q, s, t, p);
  vec4 get qstq() => new vec4(q, s, t, q);
  vec4 get qsps() => new vec4(q, s, p, s);
  vec4 get qspt() => new vec4(q, s, p, t);
  vec4 get qspp() => new vec4(q, s, p, p);
  vec4 get qspq() => new vec4(q, s, p, q);
  vec4 get qsqs() => new vec4(q, s, q, s);
  vec4 get qsqt() => new vec4(q, s, q, t);
  vec4 get qsqp() => new vec4(q, s, q, p);
  vec4 get qsqq() => new vec4(q, s, q, q);
  vec4 get qtss() => new vec4(q, t, s, s);
  vec4 get qtst() => new vec4(q, t, s, t);
  vec4 get qtsp() => new vec4(q, t, s, p);
  vec4 get qtsq() => new vec4(q, t, s, q);
  vec4 get qtts() => new vec4(q, t, t, s);
  vec4 get qttt() => new vec4(q, t, t, t);
  vec4 get qttp() => new vec4(q, t, t, p);
  vec4 get qttq() => new vec4(q, t, t, q);
  vec4 get qtps() => new vec4(q, t, p, s);
  vec4 get qtpt() => new vec4(q, t, p, t);
  vec4 get qtpp() => new vec4(q, t, p, p);
  vec4 get qtpq() => new vec4(q, t, p, q);
  vec4 get qtqs() => new vec4(q, t, q, s);
  vec4 get qtqt() => new vec4(q, t, q, t);
  vec4 get qtqp() => new vec4(q, t, q, p);
  vec4 get qtqq() => new vec4(q, t, q, q);
  vec4 get qpss() => new vec4(q, p, s, s);
  vec4 get qpst() => new vec4(q, p, s, t);
  vec4 get qpsp() => new vec4(q, p, s, p);
  vec4 get qpsq() => new vec4(q, p, s, q);
  vec4 get qpts() => new vec4(q, p, t, s);
  vec4 get qptt() => new vec4(q, p, t, t);
  vec4 get qptp() => new vec4(q, p, t, p);
  vec4 get qptq() => new vec4(q, p, t, q);
  vec4 get qpps() => new vec4(q, p, p, s);
  vec4 get qppt() => new vec4(q, p, p, t);
  vec4 get qppp() => new vec4(q, p, p, p);
  vec4 get qppq() => new vec4(q, p, p, q);
  vec4 get qpqs() => new vec4(q, p, q, s);
  vec4 get qpqt() => new vec4(q, p, q, t);
  vec4 get qpqp() => new vec4(q, p, q, p);
  vec4 get qpqq() => new vec4(q, p, q, q);
  vec4 get qqss() => new vec4(q, q, s, s);
  vec4 get qqst() => new vec4(q, q, s, t);
  vec4 get qqsp() => new vec4(q, q, s, p);
  vec4 get qqsq() => new vec4(q, q, s, q);
  vec4 get qqts() => new vec4(q, q, t, s);
  vec4 get qqtt() => new vec4(q, q, t, t);
  vec4 get qqtp() => new vec4(q, q, t, p);
  vec4 get qqtq() => new vec4(q, q, t, q);
  vec4 get qqps() => new vec4(q, q, p, s);
  vec4 get qqpt() => new vec4(q, q, p, t);
  vec4 get qqpp() => new vec4(q, q, p, p);
  vec4 get qqpq() => new vec4(q, q, p, q);
  vec4 get qqqs() => new vec4(q, q, q, s);
  vec4 get qqqt() => new vec4(q, q, q, t);
  vec4 get qqqp() => new vec4(q, q, q, p);
  vec4 get qqqq() => new vec4(q, q, q, q);
  vec4 add(vec4 arg) {
    x = x + arg.x;
    y = y + arg.y;
    z = z + arg.z;
    w = w + arg.w;
    return this;
  }
  vec4 sub(vec4 arg) {
    x = x - arg.x;
    y = y - arg.y;
    z = z - arg.z;
    w = w - arg.w;
    return this;
  }
  vec4 multiply(vec4 arg) {
    x = x * arg.x;
    y = y * arg.y;
    z = z * arg.z;
    w = w * arg.w;
    return this;
  }
  vec4 div(vec4 arg) {
    x = x / arg.x;
    y = y / arg.y;
    z = z / arg.z;
    w = w / arg.w;
    return this;
  }
  vec4 scale(num arg) {
    x = x * arg;
    y = y * arg;
    z = z * arg;
    w = w * arg;
    return this;
  }
  vec4 negate() {
    x = -x;
    y = -y;
    z = -z;
    w = -w;
    return this;
  }
  vec4 absolute() {
    x = x.abs();
    y = y.abs();
    z = z.abs();
    w = w.abs();
    return this;
  }
  vec4 copyInto(vec4 arg) {
    arg.x = x;
    arg.y = y;
    arg.z = z;
    arg.w = w;
    return arg;
  }
  vec4 copyFrom(vec4 arg) {
    x = arg.x;
    y = arg.y;
    z = arg.z;
    w = arg.w;
    return this;
  }
  vec4 set(vec4 arg) {
    x = arg.x;
    y = arg.y;
    z = arg.z;
    w = arg.w;
    return this;
  }
  vec4 setComponents(num x_, num y_, num z_, num w_) {
    x = x_;
    y = y_;
    z = z_;
    w = w_;
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
    array[i] = w;
    i++;
  }
  /// Returns a copy of [this] as a [Float32Array].
  Float32Array copyAsArray() {
    Float32Array array = new Float32Array(4);
    int i = 0;
    array[i] = x;
    i++;
    array[i] = y;
    i++;
    array[i] = z;
    i++;
    array[i] = w;
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
    w = array[i];
    i++;
  }
}
