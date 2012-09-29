#import('dart:html');
#import('../utils/webgl_utils.dart');

void main() {
  // Get a WebGL context
  var canvas = document.query("canvas");
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
  
  // set the resolution
  var resolutionLocation = gl.getUniformLocation(program, "u_resolution");
  gl.uniform2f(resolutionLocation, canvas.width, canvas.height);
  
  // Create a buffer and put a single clipspace rectangle in it (2 triangles)
  var buffer = gl.createBuffer();
  gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, buffer);
  var vertices = [10, 20,
                  80, 20,
                  10, 30,
                  10, 30,
                  80, 20,
                  80, 30];
  gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER, new Float32Array.fromList(vertices), WebGLRenderingContext.STATIC_DRAW);
  gl.enableVertexAttribArray(positionLocation);
  gl.vertexAttribPointer(positionLocation, 2, WebGLRenderingContext.FLOAT, false, 0, 0);
  
  // draw
  gl.drawArrays(WebGLRenderingContext.TRIANGLES, 0, 6); 
}

