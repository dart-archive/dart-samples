## LocalStorage 101

A basic example showing the use of LocalStorage for persistence.

LocalStorage is a simple key/value storage interface for Strings.
Though widely supported, LocalStorage is a synchronous API. Because it involves
I/O, this interface should not be used for high throughput operations.
Consider IndexedDB as an alternative. For simple string keys and values, and as
a replacement for cookies, LocalStorage is useful.

When you enter a value in the username input in the example,
it is stored in LocalStorage.
The value is then retrieved from LocalStorage and displayed on the page.

Please report any [bugs or feature requests](http://dartbug.com/new).
