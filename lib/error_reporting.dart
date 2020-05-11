import 'dart:async';

Future<void> reportError(Object error, StackTrace stackTrace) async {
    print("Uncaught Exception: $error");
    print(stackTrace);
}