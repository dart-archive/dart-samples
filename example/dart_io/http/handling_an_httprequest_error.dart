import 'package:http/http.dart' as http;

handleSuccess(http.Response response) {
  print('something went wrong');
  print(response.body);
}

handleFailure(error) {
  print('Something went wrong.');
  print(error.message);
}

void main() {
  http.get("http://some_bogus_website.org")
    .then(handleSuccess)
    .catchError(handleFailure);
}