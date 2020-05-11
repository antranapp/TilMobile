import 'dart:async';

Future<void> reportError(Object error, StackTrace stackTrace) async {
    print("Uncaught Exception: $error");
    print(stackTrace);
}

Future<void> logException(Exception e, StackTrace stackTrace) async {
    reportError(e, stackTrace);
}
