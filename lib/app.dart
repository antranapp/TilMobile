import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/state_container.dart';
import 'ui/screen/git_setup/setting_git_setup_screen.dart';
import 'ui/screen/home_screen.dart';
import 'ui/screen/folder/folder_screen.dart';

class TilApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return _buildApp(context);
    }

    // Private helpers

    MaterialApp _buildApp(BuildContext context) {
        var stateContainer = Provider.of<StateContainer>(context);

        var initialRoute = '/folders';
        if (!stateContainer.appState.remoteGitRepoConfigured) {
            initialRoute = '/setupRemoteGit';
        }

        return MaterialApp(
            key: const ValueKey('App'),
            title: 'Today I Learned',
            initialRoute: initialRoute,
            routes: {
                '/': (context) => HomeScreen(),
                '/folders': (context) => FolderListingScreen(),
                '/setupRemoteGit': (context) => SettingGitSetupScreen(stateContainer.completeGitHostSetup),
            },
        );
    }

}