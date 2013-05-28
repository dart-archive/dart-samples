library hop_runner;

import 'dart:async';
import 'dart:io';
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

void main() {

  var samples = [ 'web/appcache/beginner/appcache.dart',
                  'web/canvas/hidpi/hidpi.dart',
                  'web/canvas/imagefilters/imagefilters.dart',
                  'web/dnd/basics/basics.dart',
                  'web/file/dndfiles/dndfiles.dart',
                  'web/file/dndfiles/monitoring.dart',
                  'web/file/dndfiles/slicing.dart',
                  'web/file/filesystem/filesystem.dart',
                  'web/file/terminal/terminal_filesystem.dart',
                  'web/geolocation/trip_meter/trip_meter.dart',
                  'web/indexeddb/todo/todo.dart',
                  'web/localstorage/basics/localstorage.dart',
                  'web/notifications/quick/notifications_sample.dart',
                  'web/pointerlock/fps/fps.dart',
                  'web/speed/animations/animations.dart',
                  'web/video/basics/video.dart',
                  'web/webaudio/intro/filter_sample.dart',
                  'web/webgl/2d_image/2d_image.dart',
                  'web/webgl/2d_image_3x3_convolution/2d_image_3x3_convolution.dart',
                  'web/webgl/2d_image_blend/2d_image_blend.dart',
                  'web/webgl/2d_image_processing/2d_image_processing.dart',
                  'web/webgl/2d_image_red_2_blue/2d_image_red_2_blue.dart',
                  'web/webgl/fundamentals/fundamentals.dart',
                  'web/webgl/rectangle/rectangle.dart',
                  'web/webgl/rectangles/rectangles.dart',
                  'web/webgl/rectangle_top_left/rectangle_top_left.dart',
                  'web/webgl/utils/webgl_utils.dart',
                  'web/websockets/basics/websocket_sample.dart' ];

  addTask('analyze_web', createDartAnalyzerTask(samples));

  runHop();
}