// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class Shader {
  final String vertexShaderSource;
  final String fragmentShaderSource;
  WebGLShader vertexShader;
  WebGLShader fragmentShader;
  WebGLProgram program;

  Shader(this.vertexShaderSource, this.fragmentShaderSource);

  void compile(WebGLRenderingContext gl) {
    vertexShader = gl.createShader(WebGLRenderingContext.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertexShaderSource);
    gl.compileShader(vertexShader);
    // Print compile log
    printLog(gl.getShaderInfoLog(vertexShader));

    fragmentShader = gl.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderSource);
    gl.compileShader(fragmentShader);
    // Print compile log
    printLog(gl.getShaderInfoLog(fragmentShader));
  }

  void link(WebGLRenderingContext gl) {
    program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    printLog(gl.getProgramInfoLog(program));
    dumpUniforms(gl);
    dumpAttributes(gl);
  }

  void dumpUniforms(WebGLRenderingContext gl) {
    final int numUniforms = gl.getProgramParameter(program,
                                 WebGLRenderingContext.ACTIVE_UNIFORMS);
    printLog('Dumping active uniforms:');
    for (int i = 0; i < numUniforms; i++) {
      var uniform = gl.getActiveUniform(program, i);
      printLog('[$i] - ${uniform.name}');
    }
  }

  void dumpAttributes(WebGLRenderingContext gl) {
    final int numAttributes = gl.getProgramParameter(program,
                                WebGLRenderingContext.ACTIVE_ATTRIBUTES);
    printLog('Dumping active attributes:');
    for (int i = 0; i < numAttributes; i++) {
      var attribute = gl.getActiveAttrib(program, i);
      printLog('[$i] - ${attribute.name}');
    }
  }
}
