library utils;
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;

WebGL.Program createProgram(WebGL.RenderingContext gl, [List<WebGL.Shader> shaders]) {
  // Create program
  var program = gl.createProgram();

  // Iterate the shaders list
  if (shaders is List<WebGL.Shader>) {
    shaders.forEach((var shader) => gl.attachShader(program, shader));
  }

  // Link the shader to program
  gl.linkProgram(program);

  // Check the linked status
  var linked = gl.getProgramParameter(program, WebGL.RenderingContext.LINK_STATUS);
  if (!linked) {
    throw "Not able to link shader(s) ${shaders}";
  }

  return program;
}

WebGL.Shader loadShader(WebGL.RenderingContext gl, String shaderSource, int shaderType) {
  // Create the shader object
  var shader = gl.createShader(shaderType);

  // Load the shader source
  gl.shaderSource(shader, shaderSource);

  // Compile the shader
  gl.compileShader(shader);

  // Check the compile status
  // NOTE: getShaderParameter maybe borken in minfrog or frog compiler.
  var compiled = gl.getShaderParameter(shader, WebGL.RenderingContext.COMPILE_STATUS);
  if (!compiled) {
    throw "Not able to compile shader $shaderSource";
  }

  return shader;
}

WebGL.Shader createShaderFromScriptElement(WebGL.RenderingContext gl, String id) {
  ScriptElement shaderScript = querySelector(id);
  String shaderSource = shaderScript.text;
  int shaderType;
  if (shaderScript.type == "x-shader/x-vertex") {
    shaderType = WebGL.RenderingContext.VERTEX_SHADER;
  } else if (shaderScript.type == "x-shader/x-fragment") {
    shaderType = WebGL.RenderingContext.FRAGMENT_SHADER;
  } else {
    throw new Exception('*** Error: unknown shader type');
  }

  return loadShader(gl, shaderSource, shaderType);
}

WebGL.RenderingContext getWebGLContext(CanvasElement canvas) {
  return canvas.getContext("experimental-webgl");
}

// misc functions
void setRectangle(gl, x, y, width, height) {
  var x1 = x;
  var x2 = x + width;
  var y1 = y;
  var y2 = y + height;
  var vertices = [x1, y1,
                  x2, y1,
                  x1, y2,
                  x1, y2,
                  x2, y1,
                  x2, y2];
  gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertices), WebGL.RenderingContext.STATIC_DRAW);
}
