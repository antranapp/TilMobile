import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:git_bindings/git_bindings.dart';

import 'package:til/state/state_container.dart';
import 'package:til/state/app_state.dart';
import 'package:til/settings/settings.dart';
import 'package:til/apis/git.dart';
import 'package:til/utils/logger.dart';

import 'package:til/ui/screen/git_setup/setting_git_setup_screen.dart';
import 'package:til/ui/screen/home_screen.dart';

class TilApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return _buildApp(context);
    }

    // Private helpers

    MaterialApp _buildApp(BuildContext context) {
        var stateContainer = Provider.of<StateContainer>(context);

        var initialRoute = '/setupRemoteGit';

        return MaterialApp(
            key: const ValueKey('App'),
            title: 'Today I Learned',
            initialRoute: initialRoute,
            routes: {
                '/': (context) => HomeScreen(),
                '/setupRemoteGit': (context) => SettingGitSetupScreen(stateContainer.completeGitHostSetup),
            },
        );
    }

}