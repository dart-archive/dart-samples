import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as WebGL;
import '../utils/webgl_utils.dart';

List neffects = new List();

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

  WebGL.Texture createAndSetupTexture() {
    // Create a texture.
    var texture = gl.createTexture();
    gl.bindTexture(WebGL.RenderingContext.TEXTURE_2D, texture);

    // Set the parameters so we can render any size image.
    gl.texParameteri(WebGL.RenderingContext.TEXTURE_2D, WebGL.RenderingContext.TEXTURE_WRAP_S, WebGL.RenderingContext.CLAMP_TO_EDGE);
    gl.texParameteri(WebGL.RenderingContext.TEXTURE_2D, WebGL.RenderingContext.TEXTURE_WRAP_T, WebGL.RenderingContext.CLAMP_TO_EDGE);
    gl.texParameteri(WebGL.RenderingContext.TEXTURE_2D, WebGL.RenderingContext.TEXTURE_MIN_FILTER, WebGL.RenderingContext.NEAREST);
    gl.texParameteri(WebGL.RenderingContext.TEXTURE_2D, WebGL.RenderingContext.TEXTURE_MAG_FILTER, WebGL.RenderingContext.NEAREST);

    return texture;
  };

  // Create a texture and put the image in it.
  var originalImageTexture = createAndSetupTexture();
  gl.texImage2DImage(WebGL.RenderingContext.TEXTURE_2D, 0, WebGL.RenderingContext.RGBA, WebGL.RenderingContext.RGBA, WebGL.RenderingContext.UNSIGNED_BYTE, image);

  // Create 2 textures and attach them to framebuffers.
  var textures = [];
  var framebuffers = [];
  for (var i=0; i<2; ++i) {
    var texture = createAndSetupTexture();
    textures.add(texture);

    // make the texture the same size as the image
    gl.texImage2DTyped(WebGL.RenderingContext.TEXTURE_2D, 0, WebGL.RenderingContext.RGBA, image.width,
      image.height, 0, WebGL.RenderingContext.RGBA, WebGL.RenderingContext.UNSIGNED_BYTE, null);

    // Create a framebuffer
    var fbo = gl.createFramebuffer();
    framebuffers.add(fbo);
    gl.bindFramebuffer(WebGL.RenderingContext.FRAMEBUFFER, fbo);

    // Attach a texture to it.
    gl.framebufferTexture2D(WebGL.RenderingContext.FRAMEBUFFER,
      WebGL.RenderingContext.COLOR_ATTACHMENT0, WebGL.RenderingContext.TEXTURE_2D, texture, 0);

  }

  // lookup uniforms
  var resolutionLocation = gl.getUniformLocation(program, "u_resolution");
  var textureSizeLocation = gl.getUniformLocation(program, "u_textureSize");
  var kernelLocation = gl.getUniformLocation(program, "u_kernel[0]");
  var flipYLocation = gl.getUniformLocation(program, "u_flipY");

  // set the size of the image
  gl.uniform2f(textureSizeLocation, image.width, image.height);

  // Define several convolution kernels
  var kernels = {
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

  // Create a buffer for the position of the rectangle corners.
  var positionBuffer = gl.createBuffer();
  gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, positionBuffer);
  gl.enableVertexAttribArray(positionLocation);
  gl.vertexAttribPointer(positionLocation, 2, WebGL.RenderingContext.FLOAT, false, 0, 0);

  // Set a rectangle the same size as the image.
  setRectangle(gl, 0.0, 0.0, image.width.toDouble(), image.height.toDouble());

  var effects = [
                 { "name": "normal", "on": true },
                 { "name": "gaussianBlur3", "on": false },
                 { "name": "gaussianBlur3", "on": false },
                 { "name": "gaussianBlur3", "on": false },
                 { "name": "sharpness", "on": false},
                 { "name": "sharpness", "on": false},
                 { "name": "sharpness", "on": false},
                 { "name": "sharpen", "on": false},
                 { "name": "sharpen", "on": false},
                 { "name": "sharpen", "on": false},
                 { "name": "unsharpen", "on": false},
                 { "name": "unsharpen", "on": false},
                 { "name": "unsharpen", "on": false},
                 { "name": "emboss", "on": false },
                 { "name": "edgeDetect", "on": false},
                 { "name": "edgeDetect", "on": false},
                 { "name": "edgeDetect3", "on": false},
                 { "name": "edgeDetect3", "on": false}
               ];

  // Setup a UI
  var ui = document.querySelector('#ui');
  var table = new Element.tag('table');
  var tbody = new Element.tag('tbody');

  setFramebuffer(l_fbo, l_width, l_height) {
    // make this the framebuffer we are rendering to.
    gl.bindFramebuffer(WebGL.RenderingContext.FRAMEBUFFER, l_fbo);

    // Tell the shader the resolution of the framebuffer.
    gl.uniform2f(resolutionLocation, l_width, l_height);

    // Tell webgl the viewport setting needed for framebuffer;
    gl.viewport(0, 0, l_width, l_height);
  };

  // Setup method to draw arrays
  drawWithKernel(name) {
    // set the kernel
    gl.uniform1fv(kernelLocation,
        new Float32List.fromList(kernels[name].map((n)=>n.toDouble()).toList()));

    // Draw the rectangle.
    gl.drawArrays(WebGL.RenderingContext.TRIANGLES, 0, 6);
  };

  drawEffects() {
    // start with the original image
    gl.bindTexture(WebGL.RenderingContext.TEXTURE_2D, originalImageTexture);

    // don't y flip images while drawing to the textures
    gl.uniform1f(flipYLocation, 1);

    // loop through each effect we want to apply.
    var count = 0;
    neffects.forEach((var effect) {
        // Setup to draw into one of the framebuffers.
        setFramebuffer(framebuffers[count%2], image.width, image.height);

        drawWithKernel(effect);

        // for the next draw, use the texture we just rendered to.
        gl.bindTexture(WebGL.RenderingContext.TEXTURE_2D, textures[count%2]);

        // increment count so we use the other texture next time.
        ++count;
    });

    // finally draw the result to the canvas.
    gl.uniform1f(flipYLocation, -1); // need to y flip for canvas
    setFramebuffer(null, canvas.width, canvas.height);
    drawWithKernel("normal");
  };

  List selects = new List();
  // This is a little brain dead
  for (int i=0; i<effects.length; ++i) {
    var select = new Element.tag('select');
    selects.add(select);
    for (int j=0; j<effects.length; j++) {
      effects.forEach((effect) {
        OptionElement option = new Element.tag('option');
        option.value = effect["name"];
        if (effect["name"] == "normal") {
          option.selected = true;
        }
        option.text = effect["name"];
        select.nodes.add(option);
      });
    }
  }

  // Its late and I'm tired. :(
  List sss = selects; // Avoid bug with closure over selects
  selects.forEach((s) {
    ui.nodes.add(s);
    s.onChange.listen((event) {
      neffects.clear();
      int ncount=0;
      sss.forEach((select) {
        if (!(select.name == "normal" && ncount != 0)) {
          neffects.add(select.value);
        }

        if (select.name =="normal" && ncount==0) {
          ncount++;
        }
      });
      // On a value change draw the effects.
      drawEffects();
    });
  });

  drawEffects();
}
