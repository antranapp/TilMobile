import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:git_bindings/git_bindings.dart';
import 'package:provider/provider.dart';

import 'package:til/base/notes_folder.dart';
import 'package:til/base/notes_folder_fs.dart';
import 'package:til/settings//settings.dart';
import 'package:til/state/state_container.dart';
import 'package:til/ui/screen/topic/standard_view.dart';
import 'package:til/utils//utils.dart';
import 'package:til/base/note.dart';

class FolderView extends StatefulWidget {
    final NotesFolder notesFolder;

    FolderView({@required this.notesFolder});

    @override
    _FolderViewState createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {

    @override
    Widget build(BuildContext context) {
        var container = Provider.of<StateContainer>(context);
        final appState = container.appState;

        // If this is a Virtual folder which doesn't overwrite the FS folder's name
        // then we should use it's given name as the title
        String title = widget.notesFolder.name;
        var fsFolder = widget.notesFolder.fsFolder;
        if (fsFolder.name == widget.notesFolder.name) {
            title = widget.notesFolder.parent == null
                ? "Root Folder"
                : widget.notesFolder.pathSpec();
        }

        Widget folderView = Builder(
            builder: (BuildContext context) {
                const emptyText = "Let's add some notes?";
                var noteSelectionFn = (Note note) => openNoteEditor(context, note);
                return StandardView(
                    folder: widget.notesFolder,
                    noteSelectedFunction: noteSelectionFn,
                    emptyText: emptyText,
                );
            },
        );

        return Scaffold(
            appBar: AppBar(
                title: Text(title),
            ),
            body: Center(
                child: Scrollbar(child: folderView)
            ),
            extendBody: true,
        );
    }

    void openNoteEditor(BuildContext context, Note note) async {
        /*var route = MaterialPageRoute(
            builder: (context) => NoteEditor.fromNote(note),
        );
        var showUndoSnackBar = await Navigator.of(context).push(route);
        if (showUndoSnackBar != null) {
            Log.d("Showing an undo snackbar");

            var snackBar = buildUndoDeleteSnackbar(context, note);
            Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(snackBar);
        }*/
    }
}
