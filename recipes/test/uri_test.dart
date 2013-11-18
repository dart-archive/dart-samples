library rui_test;

import 'package:unittest/unittest.dart';

void main() {
  group('encoding and decoding URIs', () {
    test('encodeUri()', () {
      expect(Uri.encodeFull('http://www.example.com/file with spaces.html'), equals(
          'http://www.example.com/file%20with%20spaces.html'));
      var unaltered = r'#;,/?:@&=$';
      expect(Uri.encodeFull(unaltered), equals(unaltered));
      
      expect(Uri.encodeFull('http://example.com/?x=10&y=20#last'), equals('http://example.com/?x=10&y=20#last'));
      expect(Uri.encodeFull('mailto:bob@example.com'), equals('mailto:bob@example.com'));
    });
    
    test('encodeURIComponent()', () {      
      var params = Uri.encodeComponent('?param1=10&param2=20');
      expect(params, equals('%3Fparam1%3D10%26param2%3D20'));
      expect(Uri.encodeFull('http://www.example.com/') + params, equals(
          'http://www.example.com/%3Fparam1%3D10%26param2%3D20'));
      
      expect(Uri.encodeComponent('http://www.example.com/'), equals('http%3A%2F%2Fwww.example.com%2F'));
      var special = r"!'()*-._~"; // These are escaped: # $ & , / : ; = ? @ 
      expect(Uri.encodeComponent(special), equals(special));
    });
  });
  
  group('decode URIs', () {
    test('decodeUri()', () {
       var uri = 'http://www.example.com/file with spaces.html';
       var encodedUri = Uri.encodeFull(uri);
       expect(Uri.decodeFull(encodedUri) == uri, isTrue); 
    });
    test('decodeUriComponent()', () {
      var params = Uri.encodeComponent('?param1=10&param2=20');
      var encodedParams = Uri.encodeComponent(params);
      expect(Uri.decodeComponent(encodedParams) == params, isTrue);
    });
  });
  
  group('parse URIs', () {    
    test('with scheme', () {
      var uri = new Uri.http('example.org:8080', 'content/a.html#intro');
      expect(uri.isAbsolute, isTrue);
      expect(uri.scheme, equals('http'));
      expect(uri.host, equals('example.org'));
      expect(uri.path, equals('/content/a.html%23intro'));
      expect(uri.fragment, equals(''));
      expect(uri.origin, equals('http://example.org:8080'));
    });
    
    test('query params', () {
      var params = {'name=': 'john', 'age': '32'};
      var uri = new Uri.http('example.org/', '', params);
      expect(uri.query, equals('name%3D=john&age=32'));
      
      var encodedParams = Uri.encodeComponent('name%3D=john&age=32');
      uri = new Uri.http('example.org/', '?${encodedParams}');
      expect(uri.query, equals(''));      
    });

    test("absoluteness", () {
      expect(new Uri.http('example.org:8080', 'content').isAbsolute, isTrue);
      expect(new Uri.http('example.org:8080', 'content/#intro').isAbsolute, isTrue);
    });
    
    test('without scheme', () {
      var uri = new Uri.http('example.org', '/content/a.html%23intro');
      expect(uri.isAbsolute, isTrue);
      expect(uri.scheme, equals('http'));
      expect(uri.host, equals('example.org'));
      expect(uri.path, equals('/content/a.html%2523intro'));
      expect(uri.fragment, equals(''));
    });
  });
  
  group('build URIs', () {
    test('absolute', () {
      var uri = new Uri(
          scheme: 'http',
          host: 'example.org',
          path: '/content/a.html',
          query: 'name=john');
      expect(uri.isAbsolute, isTrue);
      expect(uri.toString(), equals('http://example.org/content/a.html?name=john'));
    });
    
    test('relative', () {
      var uri = new Uri(
          host: 'content/a.html');
         
      expect(uri.isAbsolute, isFalse);
      expect(uri.toString(), equals('//content/a.html'));
    });
  });
}

