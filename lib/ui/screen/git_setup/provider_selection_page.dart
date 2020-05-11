import 'package:flutter/material.dart';

import 'package:function_types/function_types.dart';

import 'package:til/ui/screen/git_setup/button.dart';
import 'package:til/apis/git/git_host_factory.dart';

class GitProviderSelectionPage extends StatelessWidget {
    final Func1<GitHostType, void> onKnownGitHost;

    GitProviderSelectionPage({
        @required this.onKnownGitHost,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Column(
                children: <Widget>[
                    Text(
                        "Select a Git Hosting Provider",
                        style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 16.0),
                    GitHostSetupButton(
                        text: "GitHub",
                        iconUrl: 'assets/icons/github-icon.png',
                        onPressed: () {
                            onKnownGitHost(GitHostType.GitHub);
                        },
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
            ),
        );
    }
}