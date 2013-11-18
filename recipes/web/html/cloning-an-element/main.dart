import 'dart:html';

void main() {
  
  var data = [
    {'src': 'http://www.google.com/logos/2013/parents_day_2013-1508005-hp.jpg', 
      'alt': "Parent's Day",
      'caption': "Parent's Day"},
    {'src': 'http://www.google.com/logos/2013/new_years_day_2013-983008-hp.jpg',
     'alt': "New Year's Day",
     'caption': "New Year's Day"},
    {'src': 'http://www.google.com/logos/2013/zamboni-1005006-hp.jpg',
     'alt': 'Zamboni',
     'caption': 'Zamboni'}
  ];

  AnchorElement link = query('a');
  
  link.onClick.listen((event) { 
    event.preventDefault();
    var content = document.query('#myTemplate').content;
    ImageElement img = content.query('img');
    DivElement div = content.query('div');

    for (Map item in data) {
      img.src = item['src'];
      img.alt = item['alt'];
      div.text = item['caption'];
      document.body.append(content.clone(true));
    }
    event.target.remove();
  });
}