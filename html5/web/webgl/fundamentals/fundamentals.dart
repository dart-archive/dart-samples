import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import '../utils/webgl_utils.dart';

void main() {
  var canvas = querySelector("canvas");
  var gl = getWebGLContext(canvas);
  if (canvas is! CanvasElement || gl is! WebGL.RenderingContext) {
    print("Failed to load canvas");
    return;
  }

  var vertexShader = createShaderFromScriptElement(gl, "#v2d-vertex-shader");
  var fragmentShader = createShaderFromScriptElement(gl, "#f2d-fragment-shader");
  var program = createProgram(gl, [vertexShader, fragmentShader]);
  gl.useProgram(program);

  // look up where the vertex data needs to go.
  var positionLocation = gl.getAttribLocation(program, "a_position");

  // Create a buffer and put a single clipspace rectangle in it (2 triangles)
  var buffer = gl.createBuffer();
  gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, buffer);
  var vertices = [-1.0, -1.0,
                   1.0, -1.0,
                  -1.0,  1.0,
                  -1.0,  1.0,
                   1.0, -1.0,
                   1.0,  1.0];
  gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertices), WebGL.RenderingContext.STATIC_DRAW);
  gl.enableVertexAttribArray(positionLocation);
  gl.vertexAttribPointer(positionLocation, 2, WebGL.RenderingContext.FLOAT, false, 0, 0);

  // draw
  gl.drawArrays(WebGL.RenderingContext.TRIANGLES, 0, 6);
}
