dart-samples
============

[![Build Status](https://drone.io/github.com/dart-lang/dart-samples/status.png)](https://drone.io/github.com/dart-lang/dart-samples/latest)

These are code samples written in [Dart](http://www.dartlang.org).
Most of them were ported from [HTML5 Rocks](http://www.html5rocks.com/).

So far, the samples cover HTML5 topics. We want to expand the scope of the
samples to cover other topics as well.

Samples
-------

Here are the samples we've created so far:

* [A Beginner's Guide to Using the Application Cache](https://github.com/dart-lang/dart-samples/tree/master/web/html5/appcache/beginner)
* [High DPI Canvas](https://github.com/dart-lang/dart-samples/tree/master/web/html5/canvas/hidpi)
* [Image Filters with Canvas](https://github.com/dart-lang/dart-samples/tree/master/web/html5/canvas/imagefilters)
* [Native HTML5 Drag and Drop](https://github.com/dart-lang/dart-samples/tree/master/web/html5/dnd/basics)
* [Reading Files in JavaScript Using the File APIs](https://github.com/dart-lang/dart-samples/tree/master/web/html5/file/dndfiles)
* [Exploring the FileSystem APIs](https://github.com/dart-lang/dart-samples/tree/master/web/html5/file/filesystem)
* [Exploring the FileSystem APIs: Web-based Terminal](https://github.com/dart-lang/dart-samples/tree/master/web/html5/file/terminal)
* [A Simple Trip Meter Using the Geolocation API](https://github.com/dart-lang/dart-samples/tree/master/web/html5/geolocation/trip_meter)
* [A Simple ToDo List Using HTML5 IndexedDB](https://github.com/dart-lang/dart-samples/tree/master/web/html5/indexeddb/todo)
* [Local Storage Basics](https://github.com/dart-lang/dart-samples/tree/master/web/html5/localstorage/basics)
* [Using the Notifications API](https://github.com/dart-lang/dart-samples/tree/master/web/html5/notifications/quick)
* [Pointer Lock And First Person Shooter Controls](https://github.com/dart-lang/dart-samples/tree/master/web/html5/pointerlock/fps)
* [Leaner, Meaner, Faster Animations with requestAnimationFrame](https://github.com/dart-lang/dart-samples/tree/master/web/html5/speed/animations)
* [HTML5 Video](https://github.com/dart-lang/dart-samples/tree/master/web/html5/video/basics)
* [Getting Started with the Web Audio API](https://github.com/dart-lang/dart-samples/tree/master/web/html5/webaudio/intro)
* [WebGL](https://github.com/dart-lang/dart-samples/tree/master/web/html5/webgl)
* [WebSockets](https://github.com/dart-lang/dart-samples/tree/master/web/html5/websockets/basics)

Setup
-----

Here's how to setup the project so that you can play with the samples
yourself:

	export DART_SDK=.../dart/dart-sdk
	export PATH=$PATH:$DART_SDK/bin
	pub install

Contributing
------------

Although we’ve ported a lot of samples, many more remain. If you’d like to
help out, this would be a great way to contribute to the Dart project!

* Read the LICENSE file.
* Sign the [Individual Contributor License Agreement](http://code.google.com/legal/individual-cla-v1.0.html).
* Submit a bug in the [issue tracker](https://github.com/dart-lang/dart-samples/issues) with the tutorial you plan on porting, so that others will know you are working on it.
* Take a look at the other examples to get a feel for how we’ve structured things.
* Fork the project on GitHub.
* Add your sample.
* Test your sample with both Dartium and dart2js.
* Update the README with a link to your sample.
* Send us a pull request.

If you’d like to chat more about this, feel free to send us email on the
[mailing list](https://groups.google.com/a/dartlang.org/forum/#!forum/misc)
or ask questions on
[Stack Overflow](http://stackoverflow.com/tags/dart)
using the "dart" tag.
