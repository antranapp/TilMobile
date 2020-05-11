import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'state/state_container.dart';
import 'state/app_state.dart';
import 'settings/settings.dart';
import 'utils/logger.dart';
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

    Log.init();

    var appState = AppState(pref);
    appState.dumpToLog();

    Log.i("Setting ${Settings.instance.toLoggableMap()}");

    if (appState.gitBaseDirectory.isEmpty) {
        var dir = await getGitBaseDirectory();
        appState.gitBaseDirectory = dir.path;
        appState.save(pref);
    }

    // ChangeNotifierProvider is the widget that provides an instance of a `ChangeNotifier` to its descendants.
    // It comes from the `provider` package.
    // Here we want to inject the StateContainer into all descendants of `TilApp`.
    // With this we can modify the `StateContainer` from anywhere in the widget tree.
    runApp(ChangeNotifierProvider(
        create: (_) {
            return StateContainer(appState);
        },
        child: ChangeNotifierProvider(
            child: TilApp(),
            create: (_) {
                assert(appState.notesFolder != null);
                return appState.notesFolder;
            },
        )
    ));
}
