library concatenating_strings;

String usePlusOperator() {
  // BEGIN(concatenating_strings_usePlusOperator)
  String s = "hello, " + "world!";
  // END(concatenating_strings_usePlusOperator)
  return s;
}

String useAdjacentStringLiterals() {
  // BEGIN(concatenating_strings_useAdjacentStringLiterals)
  String s =  "hello, " "world!";
  // END(concatenating_strings_useAdjacentStringLiterals)
  return s;
}

String useAdjacentStringLiteralsOnDifferentLines() {
  // BEGIN(concatenating_strings_useAdjacentStringLiteralsOnDifferentLines)
  String s = "hello, "
      "world!";
  // END(concatenating_strings_useAdjacentStringLiteralsOnDifferentLines)
  return s;
}

String useStringBuffer() {
  // BEGIN(concatenating_strings_useStringBuffer)
  var sb = new StringBuffer(); 
  ["hello, ", "world!"].forEach((item) {
    sb.add(item);
    });
  String s = sb.toString();
  // END(concatenating_strings_useStringBuffer)
  return sb.toString();
}

String useJoin() {
  // BEGIN(concatenating_strings_useJoin)
  String s = Strings.join(["hello", "world!"], ", "); 
  // END(concatenating_strings_useJoin)
  return s;
}

String useConcatAll() {
  // BEGIN(concatenating_strings_useConcatAll)
  String s = Strings.concatAll(["hello, ", "world!"]); 
  // END(concatenating_strings_useConcatAll)
  return s;
}