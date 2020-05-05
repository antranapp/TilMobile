import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:til/base/git_repo.dart';
import 'package:til/base/notes_folder_fs.dart';
import 'app_state.dart';
import 'package:til/utils/logger.dart';

class StateContainer with ChangeNotifier {
    final AppState appState;

    GitNoteRepository _gitRepo;

    StateContainer(this.appState) {
        if (appState.remoteGitRepoConfigured) {
            String repoPath = p.join(appState.gitBaseDirectory, appState.localGitRemoteFolderName);
            Log.d(repoPath);
            _gitRepo = GitNoteRepository(gitDirPath: repoPath);
            appState.notesFolder = NotesFolderFS(null, _gitRepo.gitDirPath);
        } else {
            _removeExistingRemoteClone();
        }
    }

    void completeGitHostSetup() async {
        appState.remoteGitRepoConfigured = true;
        await _persistConfig();
        notifyListeners();
    }

    void reset() async {
        appState.remoteGitRepoConfigured = false;
        appState.remoteGitRepoFolderName = null;
        _removeExistingRemoteClone();
        await _persistConfig();
    }

    // Private helpers

    void _removeExistingRemoteClone() async {
        var remoteGitDir = Directory(p.join(appState.gitBaseDirectory, appState.localGitRemoteFolderName));
        var dotGitDir = Directory(p.join(remoteGitDir.path, ".git"));

        bool exists = dotGitDir.existsSync();
        if (exists) {
            await remoteGitDir.delete(recursive: true);
        }
    }
    
    Future _persistConfig() async {
        var pref = await SharedPreferences.getInstance();
        appState.save(pref);
    }
}
