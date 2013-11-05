3D Solar System Simulation
==========================

A 3D solar system visualization using WebGL.

You can open the example in Dart Editor and run it by clicking
`web/solar.dart`.
Or, you can try this
[live demo](http://www.dartlang.org/samples/solar3d/).


The `solar.dart` file is the main entry point to the Dart code. This file
contains the `library solar3d` declaration.  It also contains the following
declarations listing the other files that make up the the `solar3d`
library:

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

In addition to the `dart:web_gl` library, solar3d uses the `dart:typed_array`
library for specialized integers and floating point numbers, and efficient
lists. Solar3d also uses the
[vector_math pub package](http://pub.dartlang.org/packages/vector_math).

Please report any [bugs or feature requests](http://dartbug.com/new).
