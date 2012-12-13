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
num calculateDistance(lat1, lon1, lat2, lon2) {
  const num EARTH_RADIUS = 6371; // km
  var dLat = toRad((lat2-lat1));
  var dLon = toRad((lon2-lon1));
  var a = pow(sin(dLat/2), 2) +
          cos(toRad(lat1)) * cos(toRad(lat2)) *
          pow(sin(dLon/2), 2);
  var c = 2 * atan2(sqrt(a), sqrt(1-a));
  var distance = EARTH_RADIUS * c;
  return distance;
}

num toRad(num x) {
  return x * PI / 180;
}

// Don't use alert() in real code ;)
void alertError(PositionError error) {
  window.alert("Error occurred. Error code: ${error.code}");
}

void main(){
  Geoposition startPosition;
  
  window.navigator.geolocation.getCurrentPosition((Geoposition position) {
    startPosition = position;
    query("#start-lat").text = "${startPosition.coords.latitude}";
    query("#start-lon").text = "${startPosition.coords.longitude}";
  }, (error) => alertError(error));
  
  window.navigator.geolocation.watchPosition((Geoposition position) {
    query("#current-lat").text = "${position.coords.latitude}";
    query("#current-lon").text = "${position.coords.longitude}";
    
    num distance = calculateDistance(
        startPosition.coords.latitude,
        startPosition.coords.longitude,
        position.coords.latitude,
        position.coords.longitude);
    query("#distance").text = "$distance";
  }, (error) => alertError(error));
}
