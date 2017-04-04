class Palindrome {
  String philosophy = 'Live on ';
  String get palindrome => philosophy + philosophy.split('').reversed.join();
}

void main() {
  int meaningOfLife = 42;
  double valueOfPi  = 3.141592;
  bool visible      = true;
  
  String shakespeareQuote = "All the world's a stage, ...";
      
  StringBuffer moreShakespeare = new StringBuffer();
  moreShakespeare.write('And all the men and women ');
  moreShakespeare.write('merely players; ...');
 
  var numbers = new RegExp(r'\d+');

  List superheroes = [ 'Batman', 'Superman', 'Harry Potter' ];

  Set villians = new Set();
  villians.add('Joker');
  villians.addAll( ['Lex Luther', 'Voldemort'] );
  
  Map sidekicks = { 'Batman': 'Robin',
                    'Superman': 'Lois Lane',
                    'Harry Potter': 'Ron and Hermione' };

  DateTime now = new DateTime.now();
  DateTime berlinWallFell = new DateTime(1989, 11, 9);
  DateTime moonLanding = DateTime.parse("1969-07-20");

  Duration timeRemaining = new Duration(hours:56, minutes:14);

  Uri dartlang = Uri.parse('http://dartlang.org/');
}
