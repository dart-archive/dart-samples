import 'dart:html';

void main() {
  query('a').onClick.listen((event) {
    var content = query('#myTemplate').content;
    
    ImageElement img = content.query('img');
    img.src = 'https://www.google.com/images/srpr/logo4w.png';
    img.alt = 'google logo';
    DivElement div = content.query('div');
    div.text = 'I use Google several times a day';
    document.body.append(content.clone(true));
  });
}