## Trip Meter: A Basic Geolocaton Example

A port of the Geolocation example used in the
[A Simple Trip Meter Using the Geolocation API] (http://www.html5rocks.com/en/tutorials/geolocation/trip_meter/)
article by Michael Mahemoff, originally published on HTML5Rocks.

The Geolocation API lets you track a user's location. The API is
device-agnostic; the underlying mechanism might be via GPS,
wifi, or simply asking the user to enter their location manually. Since
these lookups can take some time, the API is asynchronous, and you
pass it a callback method whenever you request a location.

The Trip Meter example display's the user's initial location, and it
tracks the distance the user has travelled since the page was loaded.

You can open the example in Dart Editor and run it by clicking `index.html`.
Or, you can try this
[live demo](http://www.dartlang.org/samples/geolocation/).

Please report any [bugs or feature requests](http://dartbug.com/new).
