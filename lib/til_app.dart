import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:til/state/state_container.dart';

import 'package:til/ui/screen/git_setup/setting_git_setup_screen.dart';
import 'package:til/ui/screen/home_screen.dart';
import 'package:til/ui/screen/topic/topic_screen.dart';

class TilApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return _buildApp(context);
    }

    // Private helpers

    MaterialApp _buildApp(BuildContext context) {
        var stateContainer = Provider.of<StateContainer>(context);

        var initialRoute = '/';
        if (!stateContainer.appState.remoteGitRepoConfigured) {
            initialRoute = '/setupRemoteGit';
        }

        return MaterialApp(
            key: const ValueKey('App'),
            title: 'Today I Learned',
            initialRoute: initialRoute,
            routes: {
                '/': (context) => FolderListingScreen(),
                '/setupRemoteGit': (context) => SettingGitSetupScreen(stateContainer.completeGitHostSetup),
            },
        );
    }

}