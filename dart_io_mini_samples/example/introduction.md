The following examples are all stand-alone apps, such as servers, that run
from the command line. Most of the examples use the `dart:io` library, which is
used solely for command-line applications running on a stand-alone Dart VM.
<strong>The `dart:io` library does not work in browser-based
applications</strong>.
Many examples also use Pub packages.

<aside class="alert alert-info" markdown="1">
**Note:**
Many server-side APIs provide both asynchronous and synchronous ways to
accomplish a task. For example, to read a file as a string you can use either
the asynchronous `readAsString()` method from the File class, or its synchronous
counterpart, `readAsStringSync()`.
<strong>The examples below use only the asynchronous versions.</strong>
</aside>