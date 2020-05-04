import 'package:flutter/material.dart';

import 'package:git_bindings/git_bindings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:til/state/state_container.dart';

import 'til_app.dart';
import 'settings/settings.dart';
import 'utils/logger.dart';
import 'state/app_state.dart';

import 'apis/git/git.dart';

/// Entry point for our application.
///
/// It tells Flutter to run the app and use `App` Widget as the entry point.
void main() async {

    // This is the glue that binds the framework to the Flutter engine.
    // We need to call this method if you need the binding to be
    // initialized before calling [runApp].
    WidgetsFlutterBinding.ensureInitialized();

    var pref = await SharedPreferences.getInstance();
    Settings.instance.load(pref);

    //Log.init();

    var appState = AppState(pref);
    appState.dumpToLog();

    Log.i("Setting ${Settings.instance.toLoggableMap()}");

    if (appState.gitBaseDirectory.isEmpty) {
        var dir = await getGitBaseDirectory();
        appState.gitBaseDirectory = dir.path;
        appState.save(pref);
    }

    if (appState.localGitRepoConfigured == false) {
        // FIXME: What about exceptions!
        appState.localGitRepoFolderName = "journal_local";
        var repoPath = p.join(
            appState.gitBaseDirectory,
            appState.localGitRepoFolderName,
        );
        await GitRepo.init(repoPath);

        appState.localGitRepoConfigured = true;
        appState.save(pref);
    }

    runApp(ChangeNotifierProvider(
        create: (_) {
            return StateContainer(appState);
        },
        child: TilApp(),
    ));
}
