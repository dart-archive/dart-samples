import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  var url = 'https://api.github.com/users/dart-lang/repos';
  http.get(url, headers : {'User-Agent': 'request'}).then((response) {
    String repos = JSON.decode(response.body);
    for (var repo in repos) {
      print("${repo['name']}, "
            "${repo['stargazers_count']} "
            "${repo['forks_count']}");
    }
  });
}