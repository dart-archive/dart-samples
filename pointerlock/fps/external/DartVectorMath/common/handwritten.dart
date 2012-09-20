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

/** Returns atan([arg]) or atan([arg]/[arg2])
  *
  * Arguments can be of type [num], [vec2], [vec3] or [vec4]
  * Return type matches input argument type
  *
  */
Dynamic atan(Dynamic arg, [Dynamic arg2]) {
  if (arg2 == null) {
    if (arg is num) {
      return Math.atan(arg);
    }
    if (arg is vec2) {
      return new vec2(Math.atan(arg.x), Math.atan(arg.y));
    }
    if (arg is vec3) {
      return new vec3(Math.atan(arg.x), Math.atan(arg.y), Math.atan(arg.z));
    }
    if (arg is vec4) {
      return new vec4(Math.atan(arg.x), Math.atan(arg.y), Math.atan(arg.z), Math.atan(arg.w));
    }  
  } else {
    if (arg is num) {
      return Math.atan2(arg, arg2);
    }
    if (arg is vec2) {
      return new vec2(Math.atan2(arg.x, arg2.x), Math.atan2(arg.y, arg2.y));
    }
    if (arg is vec3) {
      return new vec3(Math.atan2(arg.x, arg2.x), Math.atan2(arg.y, arg2.y), Math.atan2(arg.z, arg2.z));
    }
    if (arg is vec4) {
      return new vec4(Math.atan2(arg.x, arg2.x), Math.atan2(arg.y, arg2.y), Math.atan2(arg.z, arg2.z), Math.atan2(arg.w, arg2.w));
    }
  }
  
  throw new IllegalArgumentException(arg);
}

/// Returns relative error between [calculated] and [correct]. The type of [calculated] and [correct] must match and can be any vector, matrix, or quaternion.
num relativeError(Dynamic calculated, Dynamic correct) {
  if (calculated is num && correct is num) {
    num diff = (calculated - correct).abs();
    return diff/correct;
  }
  return calculated.relativeError(correct);
}

/// Returns absolute error between [calculated] and [correct]. The type of [calculated] and [correct] must match and can be any vector, matrix, or quaternion.
num absoluteError(Dynamic calculated, Dynamic correct) {
  if (calculated is num && correct is num) {
    num diff = (calculated - correct).abs();
    return diff;
  }
  return calculated.absoluteError(correct);
}