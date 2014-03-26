## Working with RequestAnimationFrame

A port of the example used in the
[Leaner, Meaner, Faster Animations with requestAnimationFrame](http://www.html5rocks.com/en/tutorials/speed/animations/)
article by Paul Lewis, originally published on HTML5Rocks.

The article explains how to correctly use requestAnimationFrame for your
animations. Here is a summary of the article contents:

* Decouple your events from animations
* Avoid animations that result in reflow-repaint loops
* Update your RAF calls to expect a high resolution timestamp as the first
parameter
* Only call RAF when you have visual updates to do

You can open the example in Dart Editor and run it by clicking `index.html`.
Or, you can try this
[live demo](http://www.dartlang.org/samples/raf/).

Use the up and down keys to activate the animation. The up key moves the
circles from right to left, and the down key moves them from left to right.

Please report any [bugs or feature requests](http://dartbug.com/new).
