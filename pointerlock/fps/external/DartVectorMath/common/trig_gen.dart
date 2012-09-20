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
/// Returns sine of [arg]. Return type matches the type of [arg]
Dynamic sin(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.sin(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = Math.sin(arg.x);
    (out as vec2).y = Math.sin(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = Math.sin(arg.x);
    (out as vec3).y = Math.sin(arg.y);
    (out as vec3).z = Math.sin(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = Math.sin(arg.x);
    (out as vec4).y = Math.sin(arg.y);
    (out as vec4).z = Math.sin(arg.z);
    (out as vec4).w = Math.sin(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns cosine of [arg]. Return type matches the type of [arg]
Dynamic cos(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.cos(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = Math.cos(arg.x);
    (out as vec2).y = Math.cos(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = Math.cos(arg.x);
    (out as vec3).y = Math.cos(arg.y);
    (out as vec3).z = Math.cos(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = Math.cos(arg.x);
    (out as vec4).y = Math.cos(arg.y);
    (out as vec4).z = Math.cos(arg.z);
    (out as vec4).w = Math.cos(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns tangent of [arg]. Return type matches the type of [arg]
Dynamic tan(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.tan(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = Math.tan(arg.x);
    (out as vec2).y = Math.tan(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = Math.tan(arg.x);
    (out as vec3).y = Math.tan(arg.y);
    (out as vec3).z = Math.tan(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = Math.tan(arg.x);
    (out as vec4).y = Math.tan(arg.y);
    (out as vec4).z = Math.tan(arg.z);
    (out as vec4).w = Math.tan(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns arc sine of [arg]. Return type matches the type of [arg]
Dynamic asin(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.asin(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = Math.asin(arg.x);
    (out as vec2).y = Math.asin(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = Math.asin(arg.x);
    (out as vec3).y = Math.asin(arg.y);
    (out as vec3).z = Math.asin(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = Math.asin(arg.x);
    (out as vec4).y = Math.asin(arg.y);
    (out as vec4).z = Math.asin(arg.z);
    (out as vec4).w = Math.asin(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns arc cosine of [arg]. Return type matches the type of [arg]
Dynamic acos(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return Math.acos(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = Math.acos(arg.x);
    (out as vec2).y = Math.acos(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = Math.acos(arg.x);
    (out as vec3).y = Math.acos(arg.y);
    (out as vec3).z = Math.acos(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = Math.acos(arg.x);
    (out as vec4).y = Math.acos(arg.y);
    (out as vec4).z = Math.acos(arg.z);
    (out as vec4).w = Math.acos(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] converted from degrees to radians. Return types matches the type of [arg]
Dynamic radians(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.radians(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.radians(arg.x);
    (out as vec2).y = _ScalerHelpers.radians(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.radians(arg.x);
    (out as vec3).y = _ScalerHelpers.radians(arg.y);
    (out as vec3).z = _ScalerHelpers.radians(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.radians(arg.x);
    (out as vec4).y = _ScalerHelpers.radians(arg.y);
    (out as vec4).z = _ScalerHelpers.radians(arg.z);
    (out as vec4).w = _ScalerHelpers.radians(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] converted from radians to degrees. Return types matches the type of [arg]
Dynamic degrees(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.degrees(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.degrees(arg.x);
    (out as vec2).y = _ScalerHelpers.degrees(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.degrees(arg.x);
    (out as vec3).y = _ScalerHelpers.degrees(arg.y);
    (out as vec3).z = _ScalerHelpers.degrees(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.degrees(arg.x);
    (out as vec4).y = _ScalerHelpers.degrees(arg.y);
    (out as vec4).z = _ScalerHelpers.degrees(arg.z);
    (out as vec4).w = _ScalerHelpers.degrees(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
