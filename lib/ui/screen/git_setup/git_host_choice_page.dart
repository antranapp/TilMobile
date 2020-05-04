import 'package:flutter/material.dart';

import 'package:function_types/function_types.dart';

import 'package:til/ui/screen/git_setup/git_host_setup_button.dart';
import 'package:til/apis/git_host_factory.dart';

class GitHostChoicePage extends StatelessWidget {
    final Func1<GitHostType, void> onKnownGitHost;
    final Func0<void> onCustomGitHost;

    GitHostChoicePage({
        @required this.onKnownGitHost,
        @required this.onCustomGitHost,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Column(
                children: <Widget>[
                    Text(
                        "Select a Git Hosting Provider -",
                        style: Theme.of(context).textTheme.headline,
                    ),
                    const SizedBox(height: 16.0),
                    GitHostSetupButton(
                        text: "GitHub",
                        iconUrl: 'assets/icons/github-icon.png',
                        onPressed: () {
                            onKnownGitHost(GitHostType.GitHub);
                        },
                    ),
                    const SizedBox(height: 8.0),
                    GitHostSetupButton(
                        text: "GitLab",
                        iconUrl: 'assets/icon/gitlab-icon.png',
                        onPressed: () async {
                            onKnownGitHost(GitHostType.GitLab);
                        },
                    ),
                    const SizedBox(height: 8.0),
                    GitHostSetupButton(
                        text: "Custom",
                        onPressed: () async {
                            onCustomGitHost();
                        },
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
            ),
        );
    }
}