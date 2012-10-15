import 'dart:html';
import '../utils/webgl_utils.dart';
import 'dart:math';

void main() {
  Random random = new Random();
  // Get a WebGL context
  var canvas = query("canvas");
  var gl = getWebGLContext(canvas);
  if (canvas is! CanvasElement || gl is! WebGLRenderingContext) {
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
  gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, buffer);
  gl.enableVertexAttribArray(positionLocation);
  gl.vertexAttribPointer(positionLocation, 2, WebGLRenderingContext.FLOAT, false, 0, 0);
  
  // draw 50 random rectangles in random colors
  for (int i=0; i<50; ++i) {
    // Setup a random rectangle
    setRectangle(gl, random.nextInt(300), random.nextInt(300), random.nextInt(300), random.nextInt(300));
    
    // Set a random color.
    gl.uniform4f(colorLocation, random.nextDouble(), random.nextDouble(), random.nextDouble(), 1);
    
    // Draw the rectangle.
    gl.drawArrays(WebGLRenderingContext.TRIANGLES, 0, 6);
  }
}
