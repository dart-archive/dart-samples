/// Use the `split()` function in the `path` Pub package to split a path into
/// its components.
///
import 'package:path/path.dart' as path;

void main() {
  print(path.split('/Users/shailen')); // Prints ['/', 'Users', 'shailen'].
  print(path.split(r'C:\tempdir\tmp.txt')); // Prints [r'C:\', 'tempdir', 'tmp.txt'])
}