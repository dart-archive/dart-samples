// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class Shader {
  final String vertexShaderSource;
  final String fragmentShaderSource;
  WebGL.Shader vertexShader;
  WebGL.Shader fragmentShader;
  WebGL.Program program;

  Shader(this.vertexShaderSource, this.fragmentShaderSource);

  void compile(WebGL.RenderingContext gl) {
    vertexShader = gl.createShader(WebGL.RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertexShaderSource);
    gl.compileShader(vertexShader);
    // Print compile log
    printLog(gl.getShaderInfoLog(vertexShader));

    fragmentShader = gl.createShader(WebGL.RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderSource);
    gl.compileShader(fragmentShader);
    // Print compile log
    printLog(gl.getShaderInfoLog(fragmentShader));
  }

  void link(WebGL.RenderingContext gl) {
    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    printLog(gl.getProgramInfoLog(program));
    dumpUniforms(gl);
    dumpAttributes(gl);
  }

  void dumpUniforms(WebGL.RenderingContext gl) {
    final int numUniforms = gl.getProgramParameter(program,
                                 WebGL.RenderingContext.ACTIVE_UNIFORMS);
    printLog('Dumping active uniforms:');
    for (var i = 0; i < numUniforms; i++) {
      var uniform = gl.getActiveUniform(program, i);
      printLog('[$i] - ${uniform.name}');
    }
  }

  void dumpAttributes(WebGL.RenderingContext gl) {
    final int numAttributes = gl.getProgramParameter(program,
                                WebGL.RenderingContext.ACTIVE_ATTRIBUTES);
    printLog('Dumping active attributes:');
    for (var i = 0; i < numAttributes; i++) {
      var attribute = gl.getActiveAttrib(program, i);
      printLog('[$i] - ${attribute.name}');
    }
  }
}
