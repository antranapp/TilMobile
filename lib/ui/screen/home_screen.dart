import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:til/state/state_container.dart';
import 'package:til/ui/widget/app_drawer.dart';
import 'package:til/ui/widget/note_viewer.dart';
import 'package:til/ui/widget/sync_button.dart';

class HomeScreen extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        var appState = Provider
            .of<StateContainer>(context)
            .appState;
        var rootFolder = appState.notesFolder;
        var readmeNote = rootFolder.getNoteWithSpec("README.md");
        return Scaffold(
            appBar: AppBar(
                title: Text("Today I Learned"),
                actions: <Widget>[
                    if (appState.remoteGitRepoConfigured) SyncButton(),
                ],
            ),
            body: NoteViewer(note: readmeNote),
            drawer: AppDrawer(),
        );
    }

}