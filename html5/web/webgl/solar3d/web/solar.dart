// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * A solar system visualization.
 */

library solar3d;

import 'dart:async';
import 'dart:html';
import 'dart:convert';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

part 'sphere_model_data.dart';
part 'sphere_model.dart';
part 'shader.dart';
part 'planet_shader.dart';
part 'texture_manager.dart';
part 'grid.dart';
part 'camera.dart';
part 'sphere_controller.dart';
part 'skybox.dart';
part 'orbit_path.dart';

class Solar3DApplication {
  WebGL.RenderingContext glContext;
  CanvasElement canvas;
  PlanetShader planetShader;
  TextureManager textureManager;
  Math.Random random = new Math.Random();
  Camera camera = new Camera();
  Skybox skyBox;
  int get width => canvas.width;
  int get height => canvas.height;
  MouseSphereCameraController controller = new MouseSphereCameraController();
  SolarSystem solarSystem;
  OrbitPath orbitPath;
  bool ownMouse = false;

  String getBaseUrl() {
    var location = window.location.href;
    return "${location.substring(0, location.length - "solar.html".length)}";
  }

  void startup(String canvasId) {
    canvas = querySelector(canvasId);
    glContext = canvas.getContext('experimental-webgl');
    if (glContext == null) {
      canvas.parent.text = ">>> Browser does not support WebGL <<<";
      return;
    }
    var baseUrl = getBaseUrl();
    baseUrl = '${baseUrl}textures/';
    textureManager = new TextureManager(baseUrl, glContext);
    solarSystem = new SolarSystem();
    skyBox = new Skybox(glContext);
    orbitPath = new OrbitPath(glContext);
    // Measure the canvas element.
    canvas.width = canvas.parent.client.width;
    canvas.height = 400;

    Future f = setupAssets();
    f.then((_) {
      bind();
      camera.aspectRatio = canvas.width / canvas.height;
      // Initialize the planets and start the simulation.
      solarSystem.start();
      requestRedraw();
    });
  }

  Future setupAssets() {
    SphereModel.setup(glContext);
    planetShader = new PlanetShader(glContext);
    planetShader.prepare();
    SphereModel.bindToProgram(glContext, planetShader.program);
    return loadTextures();
  }

  Future loadTextures() {
    var futures = new List<Future>();
    futures.add(textureManager.load('earth_diffuse.jpg'));
    futures.add(textureManager.load('sun_diffuse.jpg'));
    futures.add(textureManager.load('mars_diffuse.jpg'));
    futures.add(textureManager.load('venus_diffuse.jpg'));
    futures.add(textureManager.load('mercury_diffuse.jpg'));
    futures.add(textureManager.load('moon_diffuse.jpg'));
    futures.add(textureManager.load('jupiter_diffuse.jpg'));
    futures.add(textureManager.load('saturn_diffuse.jpg'));
    futures.add(textureManager.load('uranus_diffuse.jpg'));
    futures.add(textureManager.load('neptune_diffuse.jpg'));
    futures.add(textureManager.loadCube('Sky', [
                                          'positiveX.jpg',
                                          'negativeX.jpg',
                                          'positiveY.jpg',
                                          'negativeY.jpg',
                                          'positiveZ.jpg',
                                          'negativeZ.jpg',
                                          ]));
    return Future.wait(futures);
  }

  bool get _fullScreened => canvas == document.fullscreenElement;

  void clicked(Event event) {
    canvas.requestPointerLock();
  }

  /* Returns true if the pointer is owned by our canvas element */
  bool get _pointerLocked => canvas == document.pointerLockElement;

  void pointerLockChange(Event event) {
    // Check if we own the mouse.
    ownMouse = _pointerLocked;
  }

  void toggleFullscreen() {
    if (_fullScreened) {
      document.exitFullscreen();
    } else {
      canvas.requestFullscreen();
    }
  }

  var keyCodeLeft = 37;
  var keyCodeRight = 39;

  var keyCodeE = 69;
  var keyCodeF = 70;
  var keyCodeJ = 74;
  var keyCodeS = 83;

  void keydown(KeyboardEvent event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }
  }

  void keyup(KeyboardEvent event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }
    if (event.keyCode == keyCodeLeft) {
      solarSystem.selectPreviousPlanet();
    }
    if (event.keyCode == keyCodeRight) {
      solarSystem.selectNextPlanet();
    }
    if (event.keyCode == keyCodeJ) {
      solarSystem.selectPlanet('Jupiter');
    }
    if (event.keyCode == keyCodeS) {
      solarSystem.selectPlanet('Sun');
    }
    if (event.keyCode == keyCodeF) {
      toggleFullscreen();
    }
    if (event.keyCode == keyCodeE) {
      solarSystem.selectPlanet('Earth');
    }
  }

  void mouseMove(MouseEvent event) {
    if (!ownMouse) {
      // We don't rotate the view if we don't own the mouse
      return;
    }
    controller.accumScroll += event.movement.y;
    event.preventDefault();
  }

  void mouseWheel(MouseEvent event) {
    if (!ownMouse) {
      // We don't rotate the view if we don't own the mouse
      return;
    }
    if (event is WheelEvent) {
      WheelEvent e = event;
      controller.mouseSensitivity = 720.0;
      controller.accumDX -= e.deltaX;
      controller.accumDY += e.deltaY;
    }
    event.preventDefault();
  }

  void fullscreenChange(Event event) {
    canvas.width = canvas.parent.client.width;
    canvas.height = canvas.parent.client.height;
    camera.aspectRatio = canvas.width / canvas.height;
  }

  // Bind input event callbacks
  void bind() {
    document.onPointerLockChange.listen(pointerLockChange);
    canvas.onClick.listen(clicked);
    document.onKeyDown.listen(keydown);
    document.onKeyUp.listen(keyup);
    document.onMouseMove.listen(mouseMove);
    window.onMouseWheel.listen(mouseWheel);
    document.onFullscreenChange.listen(fullscreenChange);
  }

  double renderTime;

  void update(double time) {
    var t = new DateTime.now().millisecondsSinceEpoch;

    if (renderTime != null) {
      showFps((1000 / (t - renderTime)).round());
    }

    renderTime = t.toDouble();

    glContext.viewport(0, 0, width, height);
    glContext.clearColor(0.0, 0.0, 0.0, 1.0);
    glContext.clearDepth(1.0);
    glContext.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT |
                    WebGL.RenderingContext.DEPTH_BUFFER_BIT);

    /* Render the sky box:
     * Disable face culling
     * Disable depth testing
     */
    glContext.disable(WebGL.RenderingContext.CULL_FACE);
    glContext.disable(WebGL.RenderingContext.DEPTH_TEST);
    textureManager.bind('Sky');
    skyBox.preRender();
    skyBox.render(camera);
    /* Prepare to render planets:
     * Enable face culling
     * Enable depth testing
     */
    glContext.enable(WebGL.RenderingContext.CULL_FACE);
    glContext.enable(WebGL.RenderingContext.DEPTH_TEST);
    solarSystem.draw(glContext, controller, camera, time);
    requestRedraw();
  }

  void requestRedraw() {
    window.requestAnimationFrame(update);
  }
}

Solar3DApplication application = new Solar3DApplication();

double fpsAverage;

final bool VERBOSE = false;

/**
 * Display the animation's FPS in a div.
 */
void showFps(int fps) {
  if (fpsAverage == null) {
    fpsAverage = fps.toDouble();
  }

  fpsAverage = fps * 0.05 + fpsAverage * 0.95;

  querySelector("#notes").text = "${fpsAverage.round()} fps";
}

/**
 * A representation of the solar system.
 *
 * This class maintains a list of planetary bodies, knows how to draw its
 * background and the planets, and requests that it be redraw at appropriate
 * intervals using the [Window.requestAnimationFrame] method.
 */
class SolarSystem {
  PlanetaryBody sun;

  double globalScale = 0.1;
  SolarSystem();

  int selectedPlanet = 0;
  List<PlanetaryBody> planets = new List<PlanetaryBody>();

  start() {
    _start();
  }

  void selectNextPlanet() {
    selectedPlanet = (selectedPlanet + 1) % planets.length;
  }

  void selectPreviousPlanet() {
    selectedPlanet = (selectedPlanet - 1 ) % planets.length;
  }

  void selectPlanet(String planetName) {
    for (int i = 0; i < planets.length; i++) {
      var planet = planets[i];
      if (planet.name == planetName) {
        selectedPlanet = i;
        break;
      }
    }
  }

  _start() {
    var planet;

    // Create the Sun.
    sun = new PlanetaryBody(this,
                            "Sun", // Name
                            "sun_diffuse.jpg", // Texture
                            50.0); // Planet Size
    planets.add(sun);

    // Add planets.
    planet = new PlanetaryBody(this, "Mercury",
                               "mercury_diffuse.jpg",
                               4.0, // Planet Size
                               57.0, // Orbit distance
                               0.241); // Orbit period
    planets.add(planet);
    sun.addPlanet(planet);

    planet = new PlanetaryBody(this, "Venus",
                               "venus_diffuse.jpg",
                               8.0,
                               100.0,
                               0.615);
    sun.addPlanet(planet);
    planets.add(planet);

    var earth = new PlanetaryBody(this,
                                  "Earth",
                                  "earth_diffuse.jpg",
                                  30.0, // Planet size
                                  130.0, // Orbit distance
                                  1.0);
    sun.addPlanet(earth);
    planets.add(earth);

    planet = new PlanetaryBody(this, "Moon",
                              "moon_diffuse.jpg",
                              1.0, // Planet size
                              20.0, // Orbit distance
                              0.075);
    planets.add(planet);
    earth.addPlanet(planet);

    planet = new PlanetaryBody(this, "Mars",
                               "mars_diffuse.jpg",
                               6.0, // Planet size
                               180.0, // Orbit distance
                               1.88);
    sun.addPlanet(planet);
    planets.add(planet);

    planet = new PlanetaryBody(this,
                              "Jupiter",
                              "jupiter_diffuse.jpg",
                              20.0, // Planet Size
                              300.0, // Orbit Distance
                              11.86);
    sun.addPlanet(planet);
    planets.add(planet);

    planet = new PlanetaryBody(this,
        "Saturn",
        "saturn_diffuse.jpg",
        17.0, // Planet Size
        400.0, // Orbit Distance
        9.86);
    sun.addPlanet(planet);
    planets.add(planet);

    planet = new PlanetaryBody(this,
        "Uranus",
        "uranus_diffuse.jpg",
        10.0, // Planet Size
        450.0, // Orbit Distance
        15.86);
    sun.addPlanet(planet);
    planets.add(planet);

    planet = new PlanetaryBody(this,
        "Neptune",
        "neptune_diffuse.jpg",
        10.0, // Planet size
        500.0, // Orbit distance
        8.86);
    sun.addPlanet(planet);
    planets.add(planet);
  }

  double lastTime;

  void draw(WebGL.RenderingContext gl,
            MouseSphereCameraController controller,
            Camera camera,
            double t) {

    if (lastTime == null) {
      // This skips the first frame but gives us an origin in time.
      lastTime = t;
      return;
    }
    var dt = (t - lastTime) / 1000.0;
    lastTime = t;

    PlanetaryBody planet = planets[selectedPlanet];
    // Ensure we aren't too close to the selected body.
    controller.minRadius = planet.bodySize*2.0+0.5;
    // Adjust the camera origin to match the selected body.
    controller.origin = planet.position;
    // Update the camera.
    controller.updateCamera(dt, camera);
    /* Construct the Projection View matrix */
    var projectionMatrix = camera.projectionMatrix;
    var viewMatrix = camera.lookAtMatrix;
    projectionMatrix.multiply(viewMatrix);
    application.planetShader.enable();
    application.planetShader.cameraTransform = projectionMatrix;
    application.planetShader.viewTransform = viewMatrix;
    application.planetShader.objectScale = 1.0;
    application.orbitPath.cameraTransform = projectionMatrix;
    drawPlanets(gl);
  }

  void drawPlanets(WebGL.RenderingContext context) {
    sun.draw(context, 0.0, 0.0);
  }
}

/**
 * A representation of a plantetary body.
 *
 * This class can calculate its position for a given time index, and draw itself
 * and any child planets.
 */
class PlanetaryBody {
  final String name;
  final String texture;
  final double orbitPeriod;
  final SolarSystem solarSystem;

  double height;
  double bodySize;
  double angle;
  double orbitRadius;
  double orbitSpeed;
  Vector3 position;

  List<PlanetaryBody> planets;

  PlanetaryBody(this.solarSystem, this.name, this.texture, this.bodySize,
      [this.orbitRadius = 0.0, this.orbitPeriod = 0.0]) {
    planets = [];
    angle = 0.0;
    height = application.random.nextDouble();
    bodySize = solarSystem.globalScale*bodySize;
    orbitRadius = solarSystem.globalScale*orbitRadius;
    orbitSpeed = _calculateSpeed(orbitPeriod);
    position = new Vector3.zero();
  }

  void addPlanet(PlanetaryBody planet) {
    planets.add(planet);
  }

  void draw(WebGL.RenderingContext context, double x, double y) {
    var pos = _calculatePos(x, y);
    drawSelf(context, pos.x, pos.y, x, y);
    drawChildren(context, pos.x, pos.y);
  }

  void drawSelf(WebGL.RenderingContext context, double x, double y, double px, double py) {
    application.textureManager.bind(texture);
    var T = new Matrix4.translationValues(x.toDouble(), height, y.toDouble());
    position.x = x.toDouble();
    position.y = height;
    position.z = y.toDouble();
    angle += 0.002;
    T.rotateY(angle);
    application.planetShader.enable();
    application.planetShader.objectScale = bodySize;
    application.planetShader.objectTransform = T;
    SphereModel.prerender(context);
    SphereModel.render(context);
    application.orbitPath.preRender();
    application.orbitPath.render(orbitRadius,
        new Vector3(px.toDouble(), height, py.toDouble()),
        new Vector4(1.0, 1.0, 0.8, 1.0));
  }

  void drawChildren(WebGL.RenderingContext context, double x, double y) {
    for (var planet in planets) {
      planet.draw(context, x, y);
    }
  }

  double _calculateSpeed(double period) {
    if (period == 0.0) {
      return 0.0;
    } else {
      return 1 / (60.0 * 24.0 * 2 * period);
    }
  }

  Vector2 _calculatePos(double x, double y) {
    if (orbitSpeed == 0.0) {
      return new Vector2(x, y);
    } else {
      double angle = application.renderTime * orbitSpeed;
      //
      return new Vector2(orbitRadius * Math.cos(angle) + x,
                      orbitRadius * Math.sin(angle) + y);
    }
  }
}

void printLog(String log) {
  if (VERBOSE && log != null && !log.isEmpty) {
    print(log);
  }
}

/**
 * The entry point to the application.
 */
void main() {
  application.startup('#container');
}
