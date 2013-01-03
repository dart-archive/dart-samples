README for GitHub Pages
=======================

This project uses GitHub pages. See
(https://help.github.com/categories/20/articles) for more information.
A copy of the project has been committed to the branch gh-pages.
The URL is (http://dart-lang.github.com/dart-html5-samples/README.md).

I haven't bothered to create an index.html yet, so
(http://dart-lang.github.com/dart-html5-samples/) currently results in a 404.

I'm using GitHub pages to host copies of a few of the samples, specifically:

* http://dart-lang.github.com/dart-html5-samples/web/file/terminal/index.html
* https://github.com/dart-lang/dart-html5-samples/tree/master/web/pointerlock/fps

To host those, I used Dart Editor to create the various .js* files, and then I
explicitly added them using "git add -f" to override the .gitignore. My plan
is to embed those samples in a blog post using iframes. I haven't yet bothered
creating a more sophisticated build system.