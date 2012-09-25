dart-html5-samples
==================

These are HTML5 samples written in Dart.

Most of them were ported from
[HTML5 Rocks](http://www.html5rocks.com/).

Learn more about [Dart](http://www.dartlang.org),
the language for structured web programming.

Setup
-----

	export DART_SDK=.../dart/dart-sdk
	export PATH=$PATH:$DART_SDK/bin
	pub install

Developing
----------

To work on dart-html5-samples, you'll need to set DartEditor >> Preferences >>
Editor >> Package directory to dart-html5-samples/packages.

Things We Want to Port First
----------------------------

 * file/dndfiles: DONE
 * dnd/basics: DONE
 * appcache/beginner
 * file/filesystem: DONE
 * getusermedia/intro: This API is not standardized yet
 * video/basics: DONE
 * workers/basics: Blocked on various bugs, including: http://code.google.com/p/dart/issues/detail?id=4689
 * webaudio/intro: Partially DONE. See the code for the list of bugs.
 * file/xhr2
 * websockets/basics: DONE
 * notifications/quick
 * indexeddb/todo: DONE
 * speed/animations: DONE

Things That Didn't Come from HTML5 Rocks
----------------------------------------

 * localstorage/basics: DONE