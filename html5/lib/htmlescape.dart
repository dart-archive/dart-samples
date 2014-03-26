library htmlescape;

/**
 * Escapes HTML-special characters of [text] so that the result can be
 * included verbatim in HTML source code, either in an element body or in an
 * attribute value.
 *
 * TODO(jjinux): We can remove this once this bug is fixed:
 * http://code.google.com/p/dart/issues/detail?id=1657
 */
String htmlEscape(String text) {
  // TODO(efortuna): A more efficient implementation.
  return text.replaceAll("&", "&amp;")
             .replaceAll("<", "&lt;")
             .replaceAll(">", "&gt;")
             .replaceAll('"', "&quot;")
             .replaceAll("'", "&apos;");
}