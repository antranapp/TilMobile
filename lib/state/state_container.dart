import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as p;

import 'app_state.dart';

class StateContainer with ChangeNotifier {
    final AppState appState;

    StateContainer(this.appState) {
        assert(appState.localGitRepoConfigured);

        // Just a fail safe
        if (!appState.remoteGitRepoConfigured) {
            _removeExistingRemoteClone();
        }
    }

    void completeGitHostSetup() async {
        appState.remoteGitRepoConfigured = true;
        appState.remoteGitRepoFolderName = "journal";
        notifyListeners();
    }

    // Private helpers

    void _removeExistingRemoteClone() async {
        var remoteGitDir = Directory(
            p.join(appState.gitBaseDirectory, appState.remoteGitRepoFolderName));
        var dotGitDir = Directory(p.join(remoteGitDir.path, ".git"));

        bool exists = dotGitDir.existsSync();
        if (exists) {
            await remoteGitDir.delete(recursive: true);
        }
    }
}
