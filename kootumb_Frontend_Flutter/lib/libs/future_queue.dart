import 'dart:async';

class FutureQueue {
  Future _next = Future.value(null);

  /// Request [operation] to be run exclusively.
  ///
  /// Waits for all previously requested operations to complete,
  /// then runs the operation and completes the returned future with the
  /// result.
  /// All creds to https://stackoverflow.com/a/42091982/2608145
  Future<T> run<T>(Future<T> Function() operation) {
    var completer = Completer<T>();
    _next.whenComplete(() {
      completer.complete(Future<T>.sync(operation));
    });
    return _next = completer.future;
  }
}
