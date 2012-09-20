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

class _ScalerHelpers {
  static final _sqrtOneHalf = 0.707106781186548;
  static num degrees(num r) {
    return r * 180.0/Math.PI;
  }
  
  static num radians(num d) {
    return d * Math.PI/180.0;
  }
  
  static num clamp(num x, num _min, num _max) {
    return x < _min ? _min : x > _max ? _max : x;
  }
  
  static num mix(num x, num y, num t) {
    return x * (1.0-t) + y * (t);
  }
  
  static num step(num edge, num x) {
    if (x < edge) {
      return 0.0;
    }
    return 1.0;
  }
  
  static num smoothstep(num edge0, num edge1, num x) {
    num t = 0.0;
    t = clamp((x - edge0)/(edge1-edge0), 0.0, 1.0);
    return (t*t)*(3.0-2.0*t);
  }
  
  static num inversesqrt(num x) {
    return 1.0 / Math.sqrt(x);
  }
  
  static num abs(num x) {
    return x.abs();
  }
  
  static num ceil(num x) {
    return x.ceil();
  }
  
  static num floor(num x) {
    return x.floor();
  }
  
  static bool isnan(num x) {
    return x.isNaN();
  }
  
  static bool isInfinite(num x) {
    return x.isInfinite();
  }
  
  static num truncate(num x) {
    return x.truncate();
  }
  
  static num sign(num x) {
    if (x > 0) {
      return 1.0;
    } else if (x == 0.0) {
      return 0.0;
    } else {
      return -1.0;
    }
  }
  
  static num fract(num x) {
    return x - x.floor();
  }
  
  static num mod(num x, num y) {
    return x % y;
  }
  
  static num round(num x) {
    return x.round();
  }
  
  static num roundEven(num x) {
    if ( (floor(x)%2==0) && (fract(x)==0.5) )
      return _ScalerHelpers.round(x)-1;
    else
      return x.round();
  }
  
  static num exp2(num x) {
    return Math.pow(2, x);
  }
  
  static num log2(num x) {
    return Math.log(x) / Math.log(2);
  }
}