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
/// Returns absolute value of [arg].
Dynamic abs(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.abs(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.abs(arg.x);
    (out as vec2).y = _ScalerHelpers.abs(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.abs(arg.x);
    (out as vec3).y = _ScalerHelpers.abs(arg.y);
    (out as vec3).z = _ScalerHelpers.abs(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.abs(arg.x);
    (out as vec4).y = _ScalerHelpers.abs(arg.y);
    (out as vec4).z = _ScalerHelpers.abs(arg.z);
    (out as vec4).w = _ScalerHelpers.abs(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns 1.0 or 0.0 or -1.0 depending on sign of [arg].
Dynamic sign(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.sign(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.sign(arg.x);
    (out as vec2).y = _ScalerHelpers.sign(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.sign(arg.x);
    (out as vec3).y = _ScalerHelpers.sign(arg.y);
    (out as vec3).z = _ScalerHelpers.sign(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.sign(arg.x);
    (out as vec4).y = _ScalerHelpers.sign(arg.y);
    (out as vec4).z = _ScalerHelpers.sign(arg.z);
    (out as vec4).w = _ScalerHelpers.sign(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns floor value of [arg].
Dynamic floor(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.floor(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.floor(arg.x);
    (out as vec2).y = _ScalerHelpers.floor(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.floor(arg.x);
    (out as vec3).y = _ScalerHelpers.floor(arg.y);
    (out as vec3).z = _ScalerHelpers.floor(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.floor(arg.x);
    (out as vec4).y = _ScalerHelpers.floor(arg.y);
    (out as vec4).z = _ScalerHelpers.floor(arg.z);
    (out as vec4).w = _ScalerHelpers.floor(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] truncated.
Dynamic trunc(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.truncate(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.truncate(arg.x);
    (out as vec2).y = _ScalerHelpers.truncate(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.truncate(arg.x);
    (out as vec3).y = _ScalerHelpers.truncate(arg.y);
    (out as vec3).z = _ScalerHelpers.truncate(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.truncate(arg.x);
    (out as vec4).y = _ScalerHelpers.truncate(arg.y);
    (out as vec4).z = _ScalerHelpers.truncate(arg.z);
    (out as vec4).w = _ScalerHelpers.truncate(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] rounded to nearest integer.
Dynamic round(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.round(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.round(arg.x);
    (out as vec2).y = _ScalerHelpers.round(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.round(arg.x);
    (out as vec3).y = _ScalerHelpers.round(arg.y);
    (out as vec3).z = _ScalerHelpers.round(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.round(arg.x);
    (out as vec4).y = _ScalerHelpers.round(arg.y);
    (out as vec4).z = _ScalerHelpers.round(arg.z);
    (out as vec4).w = _ScalerHelpers.round(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [arg] rounded to nearest even integer.
Dynamic roundEven(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.roundEven(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.roundEven(arg.x);
    (out as vec2).y = _ScalerHelpers.roundEven(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.roundEven(arg.x);
    (out as vec3).y = _ScalerHelpers.roundEven(arg.y);
    (out as vec3).z = _ScalerHelpers.roundEven(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.roundEven(arg.x);
    (out as vec4).y = _ScalerHelpers.roundEven(arg.y);
    (out as vec4).z = _ScalerHelpers.roundEven(arg.z);
    (out as vec4).w = _ScalerHelpers.roundEven(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns ceiling of [arg]
Dynamic ceil(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.ceil(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.ceil(arg.x);
    (out as vec2).y = _ScalerHelpers.ceil(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.ceil(arg.x);
    (out as vec3).y = _ScalerHelpers.ceil(arg.y);
    (out as vec3).z = _ScalerHelpers.ceil(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.ceil(arg.x);
    (out as vec4).y = _ScalerHelpers.ceil(arg.y);
    (out as vec4).z = _ScalerHelpers.ceil(arg.z);
    (out as vec4).w = _ScalerHelpers.ceil(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns fraction of [arg]
Dynamic fract(Dynamic arg, [Dynamic out=null]) {
  if (arg is num) {
    return _ScalerHelpers.fract(arg);
  }
  if (arg is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.fract(arg.x);
    (out as vec2).y = _ScalerHelpers.fract(arg.y);
    return out;
  }
  if (arg is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.fract(arg.x);
    (out as vec3).y = _ScalerHelpers.fract(arg.y);
    (out as vec3).z = _ScalerHelpers.fract(arg.z);
    return out;
  }
  if (arg is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.fract(arg.x);
    (out as vec4).y = _ScalerHelpers.fract(arg.y);
    (out as vec4).z = _ScalerHelpers.fract(arg.z);
    (out as vec4).w = _ScalerHelpers.fract(arg.w);
    return out;
  }
  throw new IllegalArgumentException(arg);
}
/// Returns [x] mod [y]
Dynamic mod(Dynamic x, Dynamic y, [Dynamic out=null]) {
  if (x is num) {
    return _ScalerHelpers.mod(x, y);
  }
  if (x is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.mod(x.x, y.x);
    (out as vec2).y = _ScalerHelpers.mod(x.y, y.y);
    return out;
  }
  if (x is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.mod(x.x, y.x);
    (out as vec3).y = _ScalerHelpers.mod(x.y, y.y);
    (out as vec3).z = _ScalerHelpers.mod(x.z, y.z);
    return out;
  }
  if (x is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.mod(x.x, y.x);
    (out as vec4).y = _ScalerHelpers.mod(x.y, y.y);
    (out as vec4).z = _ScalerHelpers.mod(x.z, y.z);
    (out as vec4).w = _ScalerHelpers.mod(x.w, y.w);
    return out;
  }
  throw new IllegalArgumentException(x);
}
/// Returns component wise minimum of [x] and [y]
Dynamic min(Dynamic x, Dynamic y, [Dynamic out=null]) {
  if (x is num) {
    return Math.min(x, y);
  }
  if (x is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = Math.min(x.x, y.x);
    (out as vec2).y = Math.min(x.y, y.y);
    return out;
  }
  if (x is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = Math.min(x.x, y.x);
    (out as vec3).y = Math.min(x.y, y.y);
    (out as vec3).z = Math.min(x.z, y.z);
    return out;
  }
  if (x is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = Math.min(x.x, y.x);
    (out as vec4).y = Math.min(x.y, y.y);
    (out as vec4).z = Math.min(x.z, y.z);
    (out as vec4).w = Math.min(x.w, y.w);
    return out;
  }
  throw new IllegalArgumentException(x);
}
/// Returns component wise maximum of [x] and [y]
Dynamic max(Dynamic x, Dynamic y, [Dynamic out=null]) {
  if (x is num) {
    return Math.max(x, y);
  }
  if (x is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = Math.max(x.x, y.x);
    (out as vec2).y = Math.max(x.y, y.y);
    return out;
  }
  if (x is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = Math.max(x.x, y.x);
    (out as vec3).y = Math.max(x.y, y.y);
    (out as vec3).z = Math.max(x.z, y.z);
    return out;
  }
  if (x is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = Math.max(x.x, y.x);
    (out as vec4).y = Math.max(x.y, y.y);
    (out as vec4).z = Math.max(x.z, y.z);
    (out as vec4).w = Math.max(x.w, y.w);
    return out;
  }
  throw new IllegalArgumentException(x);
}
/// Component wise clamp of [x] between [min_] and [max_]
Dynamic clamp(Dynamic x, Dynamic min_, Dynamic max_, [Dynamic out=null]) {
  if (x is num) {
    return _ScalerHelpers.clamp(x, min_, max_);
  }
  if (x is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.clamp(x.x, min_.x, max_.x);
    (out as vec2).y = _ScalerHelpers.clamp(x.y, min_.y, max_.y);
    return out;
  }
  if (x is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.clamp(x.x, min_.x, max_.x);
    (out as vec3).y = _ScalerHelpers.clamp(x.y, min_.y, max_.y);
    (out as vec3).z = _ScalerHelpers.clamp(x.z, min_.z, max_.z);
    return out;
  }
  if (x is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.clamp(x.x, min_.x, max_.x);
    (out as vec4).y = _ScalerHelpers.clamp(x.y, min_.y, max_.y);
    (out as vec4).z = _ScalerHelpers.clamp(x.z, min_.z, max_.z);
    (out as vec4).w = _ScalerHelpers.clamp(x.w, min_.w, max_.w);
    return out;
  }
  throw new IllegalArgumentException(x);
}
/// Linear interpolation between [x] and [y] with [t]. [t] must be between 0.0 and 1.0.
Dynamic mix(Dynamic x, Dynamic y, Dynamic t) {
  if (t is num) {
      if (x is num) {
        return _ScalerHelpers.mix(x, y, t);
      }
      if (x is vec2) {
        x = x as vec2;
        return new vec2(_ScalerHelpers.mix(x.x, y.x, t), _ScalerHelpers.mix(x.y, y.y, t));
      }
      if (x is vec3) {
        x = x as vec3;
        return new vec3(_ScalerHelpers.mix(x.x, y.x, t), _ScalerHelpers.mix(x.y, y.y, t), _ScalerHelpers.mix(x.z, y.z, t));
      }
      if (x is vec4) {
        x = x as vec4;
        return new vec4(_ScalerHelpers.mix(x.x, y.x, t), _ScalerHelpers.mix(x.y, y.y, t), _ScalerHelpers.mix(x.z, y.z, t), _ScalerHelpers.mix(x.w, y.w, t));
      }
      throw new IllegalArgumentException(x);

  } else {
      if (x is num) {
        return _ScalerHelpers.mix(x, y, t);
      }
      if (x is vec2) {
        x = x as vec2;
        return new vec2(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y));
      }
      if (x is vec3) {
        x = x as vec3;
        return new vec3(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y), _ScalerHelpers.mix(x.z, y.z, t.z));
      }
      if (x is vec4) {
        x = x as vec4;
        return new vec4(_ScalerHelpers.mix(x.x, y.x, t.x), _ScalerHelpers.mix(x.y, y.y, t.y), _ScalerHelpers.mix(x.z, y.z, t.z), _ScalerHelpers.mix(x.w, y.w, t.w));
      }
      throw new IllegalArgumentException(x);

  }
}
/// Returns 0.0 if x < [y] and 1.0 otherwise.
Dynamic step(Dynamic x, Dynamic y, [Dynamic out=null]) {
  if (x is num) {
    return _ScalerHelpers.step(x, y);
  }
  if (x is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.step(x.x, y.x);
    (out as vec2).y = _ScalerHelpers.step(x.y, y.y);
    return out;
  }
  if (x is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.step(x.x, y.x);
    (out as vec3).y = _ScalerHelpers.step(x.y, y.y);
    (out as vec3).z = _ScalerHelpers.step(x.z, y.z);
    return out;
  }
  if (x is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.step(x.x, y.x);
    (out as vec4).y = _ScalerHelpers.step(x.y, y.y);
    (out as vec4).z = _ScalerHelpers.step(x.z, y.z);
    (out as vec4).w = _ScalerHelpers.step(x.w, y.w);
    return out;
  }
  throw new IllegalArgumentException(x);
}
/// Hermite intpolation between [edge0] and [edge1]. [edge0] < [x] < [edge1].
Dynamic smoothstep(Dynamic edge0, Dynamic edge1, Dynamic x, [Dynamic out=null]) {
  if (x is num) {
    return _ScalerHelpers.smoothstep(edge0, edge1, x);
  }
  if (x is vec2) {
    if (out == null) {
      out = new vec2.zero();
    }
    (out as vec2).x = _ScalerHelpers.smoothstep(edge0.x, edge1.x, x.x);
    (out as vec2).y = _ScalerHelpers.smoothstep(edge0.y, edge1.y, x.y);
    return out;
  }
  if (x is vec3) {
    if (out == null) {
      out = new vec3.zero();
    }
    (out as vec3).x = _ScalerHelpers.smoothstep(edge0.x, edge1.x, x.x);
    (out as vec3).y = _ScalerHelpers.smoothstep(edge0.y, edge1.y, x.y);
    (out as vec3).z = _ScalerHelpers.smoothstep(edge0.z, edge1.z, x.z);
    return out;
  }
  if (x is vec4) {
    if (out == null) {
      out = new vec4.zero();
    }
    (out as vec4).x = _ScalerHelpers.smoothstep(edge0.x, edge1.x, x.x);
    (out as vec4).y = _ScalerHelpers.smoothstep(edge0.y, edge1.y, x.y);
    (out as vec4).z = _ScalerHelpers.smoothstep(edge0.z, edge1.z, x.z);
    (out as vec4).w = _ScalerHelpers.smoothstep(edge0.w, edge1.w, x.w);
    return out;
  }
  throw new IllegalArgumentException(x);
}
