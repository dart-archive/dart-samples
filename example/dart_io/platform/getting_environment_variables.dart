/// Use `Platform.environment` to get the environment for the current process.

import 'dart:io' show Platform;

void main() {
  Map<String, String> envVars = Platform.environment;
  print(envVars['PATH']);
}