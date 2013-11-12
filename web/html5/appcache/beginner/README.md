## Using Application Cache

A simple example to show the use of the Application Cache interface.

For a thorough exploration of this topic, read
[A Beginner's Guide to Using the Application
Cache](http://www.html5rocks.com/en/tutorials/appcache/beginner/),
an article by Eric Bidelman originally published on HTML5Rocks.

Application Cache allows you to specify which files the browser should cache
and make available to offline users. Your app will
load and work correctly, even if the user presses the refresh button while
offline.

You can open the example in Dart Editor and run it by clicking `index.html`.
Or, you can try this
[live demo](http://www.dartlang.org/samples/appcache/).

To see this example in action, make changes to `index.html` and then reload
the app. Your changes don't show up because the browser displays a cached
version of `index.html`. Next, change the date or version number in
appcache.mf, and reload once more. You'll be prompted to load the new version.

Please report any [bugs or feature requests](http://dartbug.com/new).
