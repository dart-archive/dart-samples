// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the COPYING file.

// This is a port of "Getting Started with the Web Audio API" (the filter
// sample) to Dart. See: http://www.html5rocks.com/en/tutorials/webaudio/intro
//
// To run this code, you must use a web server. For instance, on OS X and
// Linux, you can run the following from the current directory:
//
//   python -m SimpleHTTPServer
//
// TODO(jjinux): This works in dart2js, but not with Dartium.
// See: http://code.google.com/p/dart/issues/detail?id=5174
//      http://code.google.com/p/dart/issues/detail?id=5176
//
// TODO(jjinux): You shouldn't have to pass three arguments to
// AudioNode.connect. The last two arguments should default to 0.
// We can update this code once they fix that bug.
// See: http://code.google.com/p/dart/issues/detail?id=2023

import 'dart:html';
import 'dart:math';

typedef void OnLoadCallback(List<AudioBuffer> bufferList);

class BufferLoader {
  AudioContext audioCtx;
  List<String> urlList;
  OnLoadCallback callback;
  int _loadCount = 0;
  List<AudioBuffer> _bufferList;

  BufferLoader(this.audioCtx, this.urlList, this.callback) {
    _bufferList = new List<AudioBuffer>(urlList.length);
  }

  void load() {
    for (var i = 0; i < urlList.length; i++) {
      _loadBuffer(urlList[i], i);
    }
  }

  void _loadBuffer(String url, int index) {
    // Load the buffer asynchronously.
    var request = new HttpRequest();
    request.open("GET", url, true);
    request.responseType = "arraybuffer";
    request.on.load.add((e) => _onLoad(request, url, index));

    // Don't use alert in real life ;)
    request.on.error.add((e) => window.alert("BufferLoader: XHR error"));

    request.send();
  }

  void _onLoad(HttpRequest request, String url, int index) {
    // Asynchronously decode the audio file data in request.response.
    audioCtx.decodeAudioData(request.response, (AudioBuffer buffer) {
      if (buffer == null) {

        // Don't use alert in real life ;)
        window.alert("Error decoding file data: $url");

        return;
      }
      _bufferList[index] = buffer;
      if (++_loadCount == urlList.length) callback(_bufferList);
    });
  }
}

/**
 * This is the global, application context.
 *
 * In the JavaScript version, this stuff was in a file called init.js. I'm
 * keeping it separate of FilterSample in case we want to implement additional
 * samples.
 */
class ApplicationContext {
  // Keep track of all loaded buffers.
  Map<String, AudioBuffer> buffers;

  // Page-wide AudioContext.
  AudioContext audioCtx;

  // An object to track the buffers to load "{name: path}".
  const buffersToLoad = const {
    // There is also example.ogg and example.wav.
    "example": "sounds/example.ogg"
  };

  ApplicationContext() {
    buffers = new Map<String, AudioBuffer>();
    audioCtx = new AudioContext();
    _loadBuffers();
  }

  // Loads all sound samples into the buffers object.
  void _loadBuffers() {
    List<String> names = buffersToLoad.keys;
    List<String> paths = buffersToLoad.values;
    var bufferLoader = new BufferLoader(audioCtx, paths, (List<AudioBuffer> bufferList) {
      for (var i = 0; i < bufferList.length; i++) {
        AudioBuffer buffer = bufferList[i];
        String name = names[i];
        buffers[name] = buffer;
      }
    });
    bufferLoader.load();
  }
}

class FilterSample {
  const _LOWPASS = 0;
  const _FREQ = 5000;
  const _FREQ_MUL = 7000;
  const _QUAL_MUL = 30;
  bool _playing = false;
  ApplicationContext appCtx;
  AudioBufferSourceNode _source;
  BiquadFilterNode _filter;

  FilterSample(this.appCtx) {
    query("#play-pause-button").on.click.add((Event e) {
      _toggle();
    }, false);
    query("#enable-filter-checkbox").on.change.add((Event e) {
      bool checked = (e.currentTarget as InputElement).checked;
      _toggleFilter(checked);
    }, false);
    query("#frequency-range").on.change.add((Event e) {
      num value = double.parse((e.currentTarget as InputElement).value);
      _changeFrequency(value);
    }, false);
    query("#quality-range").on.change.add((Event e) {
      num value = double.parse((e.currentTarget as InputElement).value);
      _changeQuality(value);
    }, false);
  }

  void _play() {
    // Create the source.
    _source = appCtx.audioCtx.createBufferSource();
    _source.buffer = appCtx.buffers['example'];

    // Create the filter.
    _filter = appCtx.audioCtx.createBiquadFilter();
    _filter.type = _LOWPASS;
    _filter.frequency.value = _FREQ;

    // Connect everything.
    _source.connect(_filter, 0, 0);
    _filter.connect(appCtx.audioCtx.destination, 0, 0);

    // Play!
    // TODO(jjinux): This no longer works.
    // See: http://code.google.com/p/dart/issues/detail?id=5855
    _source.noteOn(0);
    _source.loop = true;
  }

  void _stop() {
    // TODO(jjinux): This no longer works.
    // See: http://code.google.com/p/dart/issues/detail?id=5855
    _source.noteOff(0);
  }

  void _toggle() {
    _playing ? _stop() : _play();
    _playing = !_playing;
  }

  void _toggleFilter(bool checked) {
    _source.disconnect(0);
    _filter.disconnect(0);

    // Check if we want to enable the filter.
    if (checked) {
      // Connect through the filter.
      _source.connect(_filter, 0, 0);
      _filter.connect(appCtx.audioCtx.destination, 0, 0);
    } else {
      // Otherwise, connect directly.
      _source.connect(appCtx.audioCtx.destination, 0, 0);
    }
  }

  void _changeFrequency(num value) {
    // Clamp the frequency between the minimum value (40 Hz) and half of the
    // sampling rate.
    var minValue = 40;
    var maxValue = appCtx.audioCtx.sampleRate / 2;

    // Logarithm (base 2) to compute how many octaves fall in the range.
    var numberOfOctaves = log(maxValue / minValue) / LN2;

    // Compute a multiplier from 0 to 1 based on an exponential scale.
    var multiplier = pow(2, numberOfOctaves * (value - 1.0));

    // Get back to the frequency value between min and max.
    _filter.frequency.value = maxValue * multiplier;
  }

  void _changeQuality(num value) {
    _filter.Q.value = value * _QUAL_MUL;
  }
}

void main() {
  new FilterSample(new ApplicationContext());
}