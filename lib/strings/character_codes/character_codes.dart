library character_codes;


List<int> useCharCodes() {
  // BEGIN(character_codes_use_charCodes)
  String s = "hello";
  List<int> charCodes = s.charCodes;
  // [104, 101, 108, 108, 111]
  // END(character_codes_use_charCodes)
  return charCodes;
}

int useCharCodeAt() {
  String s = "hello";
  // BEGIN(character_codes_use_charCodeAt)
  int charCode = s.charCodeAt(0); // 104
  // END(character_codes_use_charCodeAt)
  return charCode;
}

String useFromCharCodes() {
  // BEGIN(character_codes_use_fromCharCodes)
  List<int> charCodes = [104, 101, 108, 108, 111];
  String s = new String.fromCharCodes(charCodes);
  // END(character_codes_use_fromCharCodes)
  return s;
}


String useStringBuffer() {
  // BEGIN(character_codes_use_StringBuffer)
  StringBuffer sb = new StringBuffer();
  List<int> charCodes = [104, 101, 108, 108, 111];
  charCodes.forEach((charCode) {
    sb.addCharCode(charCode);
  });
  String s = sb.toString(); // "Hello" 
  // END(character_codes_use_StringBuffer)
  return s;
}

// BEGIN(character_codes_rot13)
String rot13(String s) {
  List<int> rotated = [];

  s.charCodes.forEach((charCode) {
    final int numLetters = 26;
    final int A = 65;
    final int a = 97;
    final int Z = A + numLetters;
    final int z = a + numLetters;
    
    if (charCode < A ||
        charCode > z ||
        charCode > Z && charCode < a) {
      rotated.add(charCode);
    }
    else {
      if ([A, a].some((item){
        return item <= charCode && charCode < item + 13;
      })) {
        rotated.add(charCode + 13);
      } else {
        rotated.add(charCode - 13);
      }   
    }
  });

  return (new String.fromCharCodes(rotated));
}
// END(character_codes_rot13)


List useRot13() {
  // BEGIN(character_codes_use_rot13)
  var wordList = ["Jung", "be", "purely", "barf"];
  List rotated = wordList.map((word) {
      return rot13(word);
    });
  // ["What", "or", "cheryl", "ones"]
  // END(character_codes_use_rot13)

  return rotated;
}

bool useRot13WithNonAlpha() {
  // BEGIN(character_codes_use_rot13_with_non_alpha)
  String str1 = "aMz####AmZ";
  String str2 = rot13(rot13(str1));
  // str1 == str2
  // END(character_codes_use_rot13_with_non_alpha)
  return str1 == str2;
}
