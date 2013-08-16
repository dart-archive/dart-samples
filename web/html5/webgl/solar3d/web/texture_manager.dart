// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of solar3d;

class Texture {
  final int bindingPoint;
  WebGLTexture texture;
  Texture(this.bindingPoint);
}

class TextureManager {
  final WebGLRenderingContext gl;
  final String baseURL;

  Map<String, Texture> textures;

  TextureManager(this.baseURL, this.gl) {
    textures = new Map<String, Texture>();
  }

  Texture make(String name) {
    // New texture.
    Texture t = new Texture(WebGLRenderingContext.TEXTURE_2D);
    t.texture = gl.createTexture();
    textures[name] = t;
    gl.bindTexture(t.bindingPoint, t.texture);
    return t;
  }

  void update(String name, ImageData imgData) {
    Texture t = textures[name];
    if (t == null) {
      return;
    }
    gl.bindTexture(WebGLRenderingContext.TEXTURE_2D, t.texture);
    gl.texImage2D(WebGLRenderingContext.TEXTURE_2D,
        0,
        WebGLRenderingContext.RGBA,
        WebGLRenderingContext.RGBA,
        WebGLRenderingContext.UNSIGNED_BYTE,
        imgData);
    gl.generateMipmap(WebGLRenderingContext.TEXTURE_2D);
  }

  Future load(String name) {
    Texture t = textures[name];
    if (t == null) {
      // New texture.
      t = new Texture(WebGLRenderingContext.TEXTURE_2D);
      t.texture = gl.createTexture();
      textures[name] = t;
    }
    ImageElement img = new ImageElement();
    Completer c = new Completer();
    img.onLoad.listen((_) {
      gl.bindTexture(t.bindingPoint, t.texture);
      gl.texImage2D(t.bindingPoint,
                    0,
                    WebGLRenderingContext.RGBA,
                    WebGLRenderingContext.RGBA,
                    WebGLRenderingContext.UNSIGNED_BYTE,
                    img);
      gl.generateMipmap(t.bindingPoint);
      c.complete(img.src);
    });
    img.src = '$baseURL$name';
    return c.future;
  }

  Future loadCube(String name, List<String> sides) {
    assert(sides.length == 6);
    Texture t = textures[name];
    if (t == null) {
      // New texture.
      t = new Texture(WebGLRenderingContext.TEXTURE_CUBE_MAP);
      t.texture = gl.createTexture();
      gl.bindTexture(t.bindingPoint, t.texture);
      gl.texParameteri(t.bindingPoint,
                       WebGLRenderingContext.TEXTURE_MIN_FILTER,
                       WebGLRenderingContext.LINEAR);
      gl.texParameteri(t.bindingPoint,
                       WebGLRenderingContext.TEXTURE_MAG_FILTER,
                       WebGLRenderingContext.LINEAR);
      textures[name] = t;
    }

    List<int> sideTargets = [
      WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_X,
      WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_X,
      WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Y,
      WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Y,
      WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Z,
      WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Z];

    List<Future> futures = new List<Future>();
    for (int i = 0; i < sides.length; i++) {
      ImageElement img = new ImageElement();
      Completer c = new Completer();
      futures.add(c.future);
      img.onLoad.listen((_) {
        gl.bindTexture(WebGLRenderingContext.TEXTURE_2D, null);
        gl.bindTexture(WebGLRenderingContext.TEXTURE_CUBE_MAP, null);
        gl.bindTexture(t.bindingPoint, t.texture);
        gl.texImage2D(sideTargets[i],
                      0,
                      WebGLRenderingContext.RGBA,
                      WebGLRenderingContext.RGBA,
                      WebGLRenderingContext.UNSIGNED_BYTE,
                      img);
        c.complete(img.src);
      });
      img.src = '$baseURL${sides[i]}';
    }
    return Future.wait(futures);
  }

  void bind(String name) {
    Texture t = textures[name];
    if (t == null) {
      print('Cannot find texture $name');
      return;
    }
    gl.bindTexture(WebGLRenderingContext.TEXTURE_2D, null);
    gl.bindTexture(WebGLRenderingContext.TEXTURE_CUBE_MAP, null);
    gl.bindTexture(t.bindingPoint, t.texture);
  }
}
