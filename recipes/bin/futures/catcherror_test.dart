import 'dart:async';

class Client {}

/// A barebones implementation of function to demonstrate handling different
/// errors.
Future<Client> handleAuthResponse(Map<String, String> parameters) {
  if (!parameters.containsKey('state')) {
    throw new FormatException("Invalid format. Parameter 'state' expected");
  }
  
  if (!parameters['authorized']) {
    throw new AuthorizationException('not authorized');
  }
  
  return new Future.value(Client);
}

handleFormatException(e) {}
handleAuthorizationException(e) {}

class AuthorizationException implements Exception {}

void main() {
  handleAuthResponse({'username': 'john', 'age': 23})                          
  .then((_) => '')                                             
  .catchError(handleFormatException,                                 
              test: (e) => e is FormatException)                               
  .catchError(handleAuthorizationException,                         
              test: (e) => e is AuthorizationException);
}