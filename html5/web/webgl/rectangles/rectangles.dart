import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import 'dart:math';
import '../utils/webgl_utils.dart';

void main() {
  Random random = new Random();
  // Get a WebGL context
  var canvas = querySelector("canvas");
  var gl = getWebGLContext(canvas);
  if (canvas is! CanvasElement || gl is! WebGL.RenderingContext) {
    print("Failed to load canvas");
    return;
  }

  // setup GLSL program
  var vertexShader = createShaderFromScriptElement(gl, "#v2d-vertex-shader");
  var fragmentShader = createShaderFromScriptElement(gl, "#f2d-fragment-shader");
  var program = createProgram(gl, [vertexShader, fragmentShader]);
  gl.useProgram(program);

  // look up where the vertext data needs to go.
  var positionLocation = gl.getAttribLocation(program, "a_position");

  // lookup uniforms
  var resolutionLocation = gl.getUniformLocation(program, "u_resolution");
  var colorLocation = gl.getUniformLocation(program, "u_color");

  // set the resolution
  gl.uniform2f(resolutionLocation, canvas.width, canvas.height);

  // Create a buffer.
  var buffer = gl.createBuffer();
  gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, buffer);
  gl.enableVertexAttribArray(positionLocation);
  gl.vertexAttribPointer(positionLocation, 2, WebGL.RenderingContext.FLOAT, false, 0, 0);

  // draw 50 random rectangles in random colors
  for (int i=0; i<50; ++i) {
    // Setup a random rectangle
    setRectangle(gl, random.nextInt(300).toDouble(),
        random.nextInt(300).toDouble(), random.nextInt(300).toDouble(),
        random.nextInt(300).toDouble());

    // Set a random color.
    gl.uniform4f(colorLocation, random.nextDouble(), random.nextDouble(), random.nextDouble(), 1);

    // Draw the rectangle.
    gl.drawArrays(WebGL.RenderingContext.TRIANGLES, 0, 6);
  }
}
