import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'package:til/utils/logger.dart';
import 'package:til/base/notes_folder_fs.dart';

enum SyncStatus {
    Unknown,
    Done,
    Pulling,
    Pushing,
    Error,
}

class AppState {

    String localGitRemoteFolderName = "til";
    String remoteGitRepoFolderName = "";
    bool remoteGitRepoConfigured = false;

    NotesFolderFS notesFolder;

    SyncStatus syncStatus = SyncStatus.Unknown;
    int numChanges = 0;

    //
    // Temporary
    //
    /// This is the directory where all the git repos are stored
    String gitBaseDirectory =  "";

    AppState(SharedPreferences pref) {
        remoteGitRepoConfigured = pref.getBool("remoteGitRepoConfigured") ?? false;
        remoteGitRepoFolderName = pref.getString("remoteGitRepoPath") ?? "";
        gitBaseDirectory = pref.getString("gitBaseDirectory") ?? "";
    }

    void dumpToLog() {
        Log.i(" ---- Settings ---- ");
        Log.i("remoteGitRepoConfigured: $remoteGitRepoConfigured");
        Log.i("remoteGitRepoFolderName: $remoteGitRepoFolderName");
        Log.i(" ------------------ ");
    }

    Future save(SharedPreferences pref) async {
        await pref.setBool("remoteGitRepoConfigured", remoteGitRepoConfigured);
        await pref.setString("remoteGitRepoPath", remoteGitRepoFolderName);
        await pref.setString("gitBaseDirectory", gitBaseDirectory);
    }
}
