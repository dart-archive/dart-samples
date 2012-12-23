library testing_errors_and_exceptions;

import "package:unittest/unittest.dart";

// BEGIN(testing_errors_and_exceptions_range)
List range(start, stop) {
    if (start >= stop) {
      throw new ArgumentError("start must be less than stop");
    }
    // remainder of function
}
// END(testing_errors_and_exceptions_range)

void main() {
  group("testing exceptions and errors:", () {
    // BEGIN(testing_errors_and_exceptions_throws)
    test("an exception or error occured", () {
      expect(() => range(5, 5), throws);
    });
    // END(testing_errors_and_exceptions_throws)
    
    test("the type of an error or exception", () {
      // BEGIN(testing_errors_and_exceptions_throwsA)
      expect(() => range(5, 2), throwsA(new isInstanceOf<ArgumentError>()));
      // END(testing_errors_and_exceptions_throwsA)
    });
    
    test("no error or exception occured", () {
      // BEGIN(testing_errors_and_exceptions_returnsNormally)
      expect(() => range(5, 10), returnsNormally);
      // END(testing_errors_and_exceptions_returnsNormally)
    });
    
    test("error type and error message", () {
      // BEGIN(testing_errors_and_exceptions_type_and_message_1)
      expect(() => range(5, 3), 
          throwsA(predicate((e) => e is ArgumentError && e.message == 'start must be less than stop')));
      // END(testing_errors_and_exceptions_type_and_message_1)
      
      // BEGIN(testing_errors_and_exceptions_type_and_message_2)
      expect(() => range(5, 3), 
          throwsA(allOf(isArgumentError, predicate((e) => e.message == 'start must be less than stop'))));
      // END(testing_errors_and_exceptions_type_and_message_2)
    });

    test("using built in matchers", () {
      // BEGIN(testing_errors_and_exceptions_throwsArgumentError)
      expect(() => range(2, 2), throwsArgumentError);
      // END(testing_errors_and_exceptions_throwsArgumentError)
      
      expect(() => throw new FormatException(), throwsFormatException);
      expect(() => throw new IllegalJSRegExpException('asdf', 'qwerty'), throwsIllegalJSRegExpException);
      expect(() => ['a'][1], throwsRangeError);
      expect(() => new String.nonExistentMethod(), throwsNoSuchMethodError);
      expect(() => throw new UnimplementedError(), throwsUnimplementedError);
      expect(() => throw new UnsupportedError("asdf"), throwsUnsupportedError); 
      expect(() => throw new Exception("something went wrong"), throwsException);
    });
  });

/*
// BEGIN(testing_errors_and_exceptions_matchers)
throwsException
throwsFormatException
throwsArgumentError
throwsIllegalJSRegExpException
throwsRangeError
throwsNoSuchMethodError
throwsUnimplementedError
throwsUnsupportedError
// END(testing_errors_and_exceptions_matchers)
*/
}
