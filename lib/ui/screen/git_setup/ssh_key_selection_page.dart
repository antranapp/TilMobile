import 'package:flutter/material.dart';

import 'package:function_types/function_types.dart';

import 'button.dart';

class GitSshKeySelectionPage extends StatelessWidget {
    final Func0<void> onGenerateKeys;
    final Func0<void> onUserProvidedKeys;

    GitSshKeySelectionPage({
        @required this.onGenerateKeys,
        @required this.onUserProvidedKeys,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Column(
                children: <Widget>[
                    Text(
                        "We need SSH keys to authenticate -",
                        style: Theme.of(context).textTheme.headline,
                    ),
                    const SizedBox(height: 16.0),
                    GitHostSetupButton(
                        text: "Generate new keys",
                        onPressed: onGenerateKeys,
                    ),
                    const SizedBox(height: 8.0),
                    GitHostSetupButton(
                        text: "Provide Custom SSH Keys",
                        onPressed: onUserProvidedKeys,
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
            ),
        );
    }
}
