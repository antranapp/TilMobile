import 'package:flutter/material.dart';

import 'package:til/core/notes_folder.dart';
import 'package:til/core/note.dart';

import 'common.dart';
import 'standard_view.dart';

class FolderView extends StatefulWidget {
    final NotesFolder notesFolder;

    FolderView({@required this.notesFolder});

    @override
    _FolderViewState createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {

    @override
    Widget build(BuildContext context) {
        // If this is a Virtual folder which doesn't overwrite the FS folder's name
        // then we should use it's given name as the title
        String title = widget.notesFolder.name;
        var fsFolder = widget.notesFolder.fsFolder;
        if (fsFolder.name == widget.notesFolder.name) {
            title = widget.notesFolder.parent == null
                ? "TIL"
                : widget.notesFolder.pathSpec();
        }

        Widget folderView = Builder(
            builder: (BuildContext context) {
                const emptyText = "No tils found!";
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
}
