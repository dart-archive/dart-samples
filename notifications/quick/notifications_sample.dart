// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This is a port of "Using the Notifications API" to Dart.
// See: http://www.html5rocks.com/en/tutorials/notifications/quick

// TODO(jjinux): window.webkitNotifications.createNotification raises an exception in Dartium.
// TODO(jjinux): No matter what I set the ICON_URL to, it doesn't seem to work.
//               Once I know it works, switch to using my own image.
// See: http://code.google.com/p/dart/issues/detail?id=5462

#import('dart:html');

class NotificationsSample {
  static const PERMISSION_ALLOWED = 0;
  static const ICON_URL = "http://www.blogger.com/img/icon_logo32.gif";

  NotificationsSample() {
    query('#say-hello').on.click.add((e) => sayHello(), false);
  }
  
  /**
   * When the user clicks the say-hello button, ask for permission to show
   * notifications. Then, one second later, schedule a notification.
   */
  void sayHello() {  
    if (window.webkitNotifications.checkPermission() == PERMISSION_ALLOWED) {
      scheduleNotification();
    } else {
      window.webkitNotifications.requestPermission(scheduleNotification);
    }
  }
  
  /**
   * Pause for a second, and then show a notification.
   * 
   * The reason I'm pausing is because I'm pretending an event is happening
   * later. Chrome won't let you show a notification that isn't the result of
   * a user event unless you've requested permission ahead of time. Hence,
   * I'm providing that I requested permission ahead of time.
   */
  bool scheduleNotification() {
    window.setTimeout(showNotification, 1000);
    
    // This is for window.webkitNotifications.requestPermission.
    return false; 
  }
  
  void showNotification() {
    var notification = window.webkitNotifications.createNotification(
        ICON_URL, "Hello World", "You've been notified!");
    
    // Use these if you need them.
    notification.on.display.add((e) => print("notification.on.display"));
    notification.on.close.add((e) => print("notification.on.close"));
    
    notification.show();
  }  
}

void main() {
  new NotificationsSample();  
}