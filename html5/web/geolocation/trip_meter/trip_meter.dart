// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the COPYING file.

// This is a port of "A Simple Trip Meter Using the Geolocation API" to Dart.
// See: http://www.html5rocks.com/en/tutorials/geolocation/trip_meter/

import 'dart:html';
import 'dart:math';

// Reused code - copyright Moveable Type Scripts
// http://www.movable-type.co.uk/scripts/latlong.html
// Under Creative Commons License http://creativecommons.org/licenses/by/3.0/
num calculateDistance(num lat1, num lon1, num lat2, num lon2) {
  const EARTH_RADIUS = 6371; // km
  num latDiff = lat2 - lat1;
  num lonDiff = lon2 - lon1;

  // a is the square of half the chord length between the points.
  var a = pow(sin(latDiff / 2), 2) +
          cos(lat1) * cos (lat2) *
          pow(sin(lonDiff / 2), 2);

  var angularDistance = 2 * atan2(sqrt(a), sqrt(1 - a));
  return EARTH_RADIUS * angularDistance;
}

// Don't use alert() in real code ;)
void alertError(PositionError error) {
  window.alert("Error occurred. Error code: ${error.code}");
}

void main(){
  Geoposition startPosition;

  window.navigator.geolocation.getCurrentPosition()
  .then((Geoposition position) {
    startPosition = position;
    querySelector("#start-lat").text = "${startPosition.coords.latitude}";
    querySelector("#start-lon").text = "${startPosition.coords.longitude}";
  }, onError: (error) => alertError(error));

  window.navigator.geolocation.watchPosition().listen((Geoposition position) {
    querySelector("#current-lat").text = "${position.coords.latitude}";
    querySelector("#current-lon").text = "${position.coords.longitude}";
    num distance = calculateDistance(
        startPosition.coords.latitude,
        startPosition.coords.longitude,
        position.coords.latitude,
        position.coords.longitude);
    querySelector("#distance").text = "$distance";
  }, onError: (error) => alertError(error));
}
