import 'package:flutter/material.dart';

import 'package:function_types/function_types.dart';

import 'button.dart';
import 'setup_type.dart';

class GitAutoConfigureSelectionPage extends StatelessWidget {
    final Func1<GitHostSetupType, void> onDone;

    GitAutoConfigureSelectionPage({@required this.onDone});

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Column(
                children: <Widget>[
                    Text(
                        "How do you want to do this?",
                        style: Theme.of(context).textTheme.headline,
                    ),
                    const SizedBox(height: 16.0),
                    GitHostSetupButton(
                        text: "Setup Automatically",
                        onPressed: () {
                            onDone(GitHostSetupType.Auto);
                        },
                    ),
                    const SizedBox(height: 8.0),
                    GitHostSetupButton(
                        text: "Let me do it manually",
                        onPressed: () async {
                            onDone(GitHostSetupType.Manual);
                        },
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
            ),
        );
    }
}
