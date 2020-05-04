import 'package:flutter/material.dart';

import 'error_page.dart';
import 'loading_page.dart';

class GitClonePage extends StatelessWidget {
    final String errorMessage;

    GitClonePage({
        this.errorMessage,
    });

    @override
    Widget build(BuildContext context) {
        if (errorMessage == null || errorMessage.isEmpty) {
            return GitLoadingPage("Cloning ...");
        }

        return GitErrorPage(errorMessage);
    }
}
