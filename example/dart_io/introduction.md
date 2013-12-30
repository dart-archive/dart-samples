These examples use the `dart:io` library, and the `http` and the `http_server`
Pub packages (see the `pubspec.yaml` file for a list of all the packages
used).  The `dart:io` library is used
for Dart server applications, which run on a
stand-alone Dart VM from the command line. This library does not work in
browser based applications.

<aside class="alert alert-info" markdown="1">
**Note:**
Many server-side APIs provide both asynchronous and synchronous means for
accomplishing a task. For example, to read a file as a string you can use
either the asynchronous `readAsString()` File method, or its synchronous
counterpart, `readAsStringSync()`. <strong>Only the asynchronous versions
are used in the examples below.</strong>
</aside>
