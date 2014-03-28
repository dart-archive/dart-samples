import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import '../utils/webgl_utils.dart';

//http://www.cake23.de/traveling-wavefronts-lit-up.html
void main() {
  ImageElement image = querySelector('#photo');
  render(image);
}

void render(image) {
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

  // look up where the vertex data needs to go.
  var positionLocation = gl.getAttribLocation(program, "a_position");
  var texCoordLocation = gl.getAttribLocation(program, "a_texCoord");

  // provide texture coordinates for the rectangle.
  var texCoordBuffer = gl.createBuffer();
  gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, texCoordBuffer);
  var vertices = [0.0,  0.0,
                  1.0,  0.0,
                  0.0,  1.0,
                  0.0,  1.0,
                  1.0,  0.0,
                  1.0,  1.0];
  gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertices), WebGL.RenderingContext.STATIC_DRAW);
  gl.enableVertexAttribArray(texCoordLocation);
  gl.vertexAttribPointer(texCoordLocation, 2, WebGL.RenderingContext.FLOAT, false, 0, 0);

  // Create a texture.
  var texture = gl.createTexture();
  gl.bindTexture(WebGL.RenderingContext.TEXTURE_2D, texture);

  // Set the parameters so we can render any size image.
  gl.texParameteri(WebGL.RenderingContext.TEXTURE_2D, WebGL.RenderingContext.TEXTURE_WRAP_S, WebGL.RenderingContext.CLAMP_TO_EDGE);
  gl.texParameteri(WebGL.RenderingContext.TEXTURE_2D, WebGL.RenderingContext.TEXTURE_WRAP_T, WebGL.RenderingContext.CLAMP_TO_EDGE);
  gl.texParameteri(WebGL.RenderingContext.TEXTURE_2D, WebGL.RenderingContext.TEXTURE_MIN_FILTER, WebGL.RenderingContext.NEAREST);
  gl.texParameteri(WebGL.RenderingContext.TEXTURE_2D, WebGL.RenderingContext.TEXTURE_MAG_FILTER, WebGL.RenderingContext.NEAREST);

  // Upload the image into the texture.
  gl.texImage2DImage(WebGL.RenderingContext.TEXTURE_2D, 0, WebGL.RenderingContext.RGBA, WebGL.RenderingContext.RGBA, WebGL.RenderingContext.UNSIGNED_BYTE, image);

  // lookup uniforms
  var resolutionLocation = gl.getUniformLocation(program, "u_resolution");
  var textureSizeLocation = gl.getUniformLocation(program, "u_textureSize");

  // set the resolution
  gl.uniform2f(resolutionLocation, canvas.width, canvas.height);

  // set the size of the image
  gl.uniform2f(textureSizeLocation, image.width, image.height);

  // Create a buffer for the position of the rectangle corners.
  var positionBuffer = gl.createBuffer();
  gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, positionBuffer);
  gl.enableVertexAttribArray(positionLocation);
  gl.vertexAttribPointer(positionLocation, 2, WebGL.RenderingContext.FLOAT, false, 0, 0);

  // Set a rectangle the same size as the image.
  setRectangle(gl, 0.0, 0.0, image.width.toDouble(), image.height.toDouble());

  // Draw the rectangle
  gl.drawArrays(WebGL.RenderingContext.TRIANGLES, 0, 6);
}
