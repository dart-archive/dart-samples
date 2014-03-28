import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import '../utils/webgl_utils.dart';

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
  var kernelLocation = gl.getUniformLocation(program, "u_kernel[0]");

  // set the resolution
  gl.uniform2f(resolutionLocation, canvas.width, canvas.height);

  // set the size of the image
  gl.uniform2f(textureSizeLocation, image.width, image.height);

  // Define several convolution kernels
  Map<String, List<num>> kernels = {
    "normal": [
      0, 0, 0,
      0, 1, 0,
      0, 0, 0
    ],
    "gaussianBlur": [
      0.045, 0.122, 0.045,
      0.122, 0.332, 0.122,
      0.045, 0.122, 0.045
    ],
    "gaussianBlur2": [
      1, 2, 1,
      2, 4, 2,
      1, 2, 1
    ],
    "gaussianBlur3": [
      0, 1, 0,
      1, 1, 1,
      0, 1, 0
    ],
    "unsharpen": [
      -1, -1, -1,
      -1,  9, -1,
      -1, -1, -1
    ],
    "sharpness": [
       0,-1, 0,
      -1, 5,-1,
       0,-1, 0
    ],
    "sharpen": [
       -1, -1, -1,
       -1, 16, -1,
       -1, -1, -1
    ],
    "edgeDetect": [
       -0.125, -0.125, -0.125,
       -0.125,  1,     -0.125,
       -0.125, -0.125, -0.125
    ],
    "edgeDetect2": [
       -1, -1, -1,
       -1,  8, -1,
       -1, -1, -1
    ],
    "edgeDetect3": [
       -5, 0, 0,
        0, 0, 0,
        0, 0, 5
    ],
    "edgeDetect4": [
       -1, -1, -1,
        0,  0,  0,
        1,  1,  1
    ],
    "edgeDetect5": [
       -1, -1, -1,
        2,  2,  2,
       -1, -1, -1
    ],
    "edgeDetect6": [
       -5, -5, -5,
       -5, 39, -5,
       -5, -5, -5
    ],
    "sobelHorizontal": [
        1,  2,  1,
        0,  0,  0,
       -1, -2, -1
    ],
    "sobelVertical": [
        1,  0, -1,
        2,  0, -2,
        1,  0, -1
    ],
    "previtHorizontal": [
        1,  1,  1,
        0,  0,  0,
       -1, -1, -1
    ],
    "previtVertical": [
        1,  0, -1,
        1,  0, -1,
        1,  0, -1
    ],
    "boxBlur": [
        0.111, 0.111, 0.111,
        0.111, 0.111, 0.111,
        0.111, 0.111, 0.111
    ],
    "triangleBlur": [
        0.0625, 0.125, 0.0625,
        0.125,  0.25,  0.125,
        0.0625, 0.125, 0.0625
    ],
    "emboss": [
       -2, -1,  0,
       -1,  1,  1,
        0,  1,  2
    ]
  };

  // Setup method to draw arrays
  drawWithKernel(name) {
    // set the kernel
    gl.uniform1fv(kernelLocation,
        new Float32List.fromList(kernels[name].map((n)=>n.toDouble()).toList()));

    // Draw the rectangle.
    gl.drawArrays(WebGL.RenderingContext.TRIANGLES, 0, 6);
  };


  // Setup UI to pick kernels.
  var initialSelection = 'emboss';
  var ui = querySelector('#ui');
  SelectElement select = new Element.tag('select');
  kernels.forEach((name, value) {
    OptionElement option = new Element.tag('option');
    option.value = name;
    if (name == initialSelection) {
      option.selected = true;
    }

    option.text = name;
    select.nodes.add(option);
  });

  select.onChange.listen((var event) {
    drawWithKernel(select.value);
  });

  ui.nodes.add(select);

  // Create a buffer for the position of the rectangle corners.
  var positionBuffer = gl.createBuffer();
  gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, positionBuffer);
  gl.enableVertexAttribArray(positionLocation);
  gl.vertexAttribPointer(positionLocation, 2, WebGL.RenderingContext.FLOAT, false, 0, 0);

  // Set a rectangle the same size as the image.
  setRectangle(gl, 0.0, 0.0, image.width.toDouble(), image.height.toDouble());

  drawWithKernel(initialSelection);
}

