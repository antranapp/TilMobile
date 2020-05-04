import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
    var snackBar = SnackBar(content: Text(message));
    Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
}
