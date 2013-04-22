import 'dart:uri';
import 'package:unittest/unittest.dart';

void main() {
  group('encoding and decoding URIs', () {
    test('encodeUri()', () {
      expect(encodeUri('http://www.example.com/file with spaces.html'), equals(
          'http://www.example.com/file+with+spaces.html'));
      // var special = r"!#$&'()*,-./:;=?@_~"; // These are escaped: % + < > \ ] ^ `{ | }
      var unaltered = r'#;,/?:@&=$';
      expect(encodeUri(unaltered), equals(unaltered));
      
      expect(encodeUri('http://example.com/?x=10&y=20#last'), equals('http://example.com/?x=10&y=20#last'));
      expect(encodeUri('mailto:bob@example.com'), equals('mailto:bob@example.com'));
    });
    
    test('encodeURIComponent()', () {      
      var params = encodeUriComponent('?param1=10&param2=20');
      expect(params, equals('%3Fparam1%3D10%26param2%3D20'));
      expect(encodeUri('http://www.example.com/') + params, equals(
          'http://www.example.com/%3Fparam1%3D10%26param2%3D20'));
      
      expect(encodeUriComponent('http://www.example.com/'), equals('http%3A%2F%2Fwww.example.com%2F'));
      var special = r"!'()*-._~"; // These are escaped: # $ & , / : ; = ? @ 
      expect(encodeUriComponent(special), equals(special));
    });
  });
  
  group('decode URIs', () {
    test('decodeUri()', () {
       var uri = 'http://www.example.com/file with spaces.html';
       var encodedUri = encodeUri(uri);
       expect(decodeUri(encodedUri) == uri, isTrue); 
    });
    test('decodeUriComponent()', () {
      var params = encodeUriComponent('?param1=10&param2=20');
      var encodedParams = encodeUriComponent(params);
      expect(decodeUriComponent(encodedParams) == params, isTrue);
    });
  });
  
  group('parse URIs', () {    
    test('with scheme', () {
      var uri = new Uri('http://example.org:8080/content/a.html#intro');
      expect(uri.isAbsolute, isFalse);
      expect(uri.scheme, equals('http'));
      expect(uri.domain, equals('example.org'));
      expect(uri.path, equals('/content/a.html'));
      expect(uri.fragment, equals('intro'));
      expect(uri.origin, equals('http://example.org:8080'));
    });
    
    test('query params', () {
      var params = 'name=john&age=32';
      var uri = new Uri('http://example.org/?${params}');
      expect(uri.query, equals('name=john&age=32'));
      
      var encodedParams = encodeUriComponent(params);
      uri = new Uri('http://example.org/?${encodedParams}');
      expect(uri.query, equals('name%3Djohn%26age%3D32'));      
    });

    test("absoluteness", () {
      expect(new Uri('http://example.org:8080/content/').isAbsolute, isTrue);
      expect(new Uri('//example.org:8080/content/').isAbsolute, isFalse);
      expect(new Uri('example.org:8080/content/').isAbsolute, isFalse);
      expect(new Uri('http//example.org:8080/content/#intro').isAbsolute, isFalse);
    });
    
    test('without scheme', () {
      var uri = new Uri('example.org/content/a.html#intro');
      
      expect(uri.isAbsolute, isFalse);
      expect(uri.scheme, equals(''));
      expect(uri.domain, equals(''));
      expect(uri.path, equals('example.org/content/a.html'));
      expect(uri.fragment, equals('intro'));
      
      try {
        var origin = uri.origin;
        throw 'OK to access origin of relative URI';
      } catch(e) {
        expect(e.toString(), equals('Illegal argument(s): Cannot use origin without a scheme'));
      }
      
      expect(() => uri.origin, throwsA((predicate(
          (e) => (e.message == 'Cannot use origin without a scheme')))));
    });
  });
  
  group('build URIs', () {
    test('absolute', () {
      var uri = new Uri.fromComponents(
          scheme: 'http',
          domain: 'example.org',
          path: '/content/a.html',
          query: 'name=john');
      expect(uri.isAbsolute, isTrue);
      expect(uri.toString(), equals('http://example.org/content/a.html?name=john'));
    });
    
    test('relative', () {
      var uri = new Uri.fromComponents(
          domain: 'content/a.html');
         
      expect(uri.isAbsolute, isFalse);
      expect(uri.toString(), equals('//content/a.html'));
    });
  });
}

