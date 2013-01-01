library trimming_strings;

String s = "";

String use_trim(String str) {
  // BEGIN(trimming_strings_use_trim)
  assert("   asdf   ".trim() == "asdf");
  // END(trimming_strings_use_trim)
  String s = str.trim();
  return s;
}

// BEGIN(trimming_strings_ltrim)
String ltrim(String str) {
  return str.replaceFirst(new RegExp(r"^\s+"), "");
}
// ltrim("  qwerty  ") == "qwerty  ";
// END(trimming_strings_ltrim)


// BEGIN(trimming_strings_rtrim)
String rtrim(String str) {
  return str.replaceFirst(new RegExp(r"\s+$"), "");
}
// rtrim("  qwerty  ") == "  qwerty";
// END(trimming_strings_rtrim)
