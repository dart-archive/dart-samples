import 'package:unittest/unittest.dart';
import 'dart:io';

Path commonPrefix(List<Path> paths) {
  if (paths.isEmpty) return new Path('');
  var pathSegments = paths.map((path) => path.segments()).toList();
  var first = pathSegments.first;
  var remaining = pathSegments.getRange(1, pathSegments.length);

  for (var i = 0; i < first.length; i++) {
    if (remaining.any((item) => item.length <= i) ||
        remaining.any((item) => item[i] != first[i])) {
      return new Path(first.getRange(0, i).join('/'));
    }
  }
  return new Path(first.join('/'));
}

void main() {}
