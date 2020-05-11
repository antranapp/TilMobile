import 'package:flutter/material.dart';

import 'package:til/core/note.dart';
import 'package:til/core/markdown/md_yaml_doc.dart';
import 'package:til/core/notes_folder_fs.dart';

import 'editor/markdown_editor.dart';

class ShowUndoSnackbar {}

class NoteEditor extends StatefulWidget {
    final Note note;
    final NotesFolderFS notesFolder;
    final EditorType defaultEditorType;

    NoteEditor.fromNote(this.note):
            notesFolder = note.parent,
            defaultEditorType = null;
    NoteEditor.newNote(this.notesFolder, this.defaultEditorType) : note = null;

    @override
    NoteEditorState createState() {
        if (note == null) {
            return NoteEditorState.newNote(notesFolder);
        } else {
            return NoteEditorState.fromNote(note);
        }
    }
}

enum EditorType { Markdown, Raw }

class NoteEditorState extends State<NoteEditor> {
    Note note;
    EditorType editorType = EditorType.Markdown;
    MdYamlDoc originalNoteData = MdYamlDoc();

    final _markdownEditorKey = GlobalKey<MarkdownEditorState>();

    bool get _isNewNote {
        return widget.note == null;
    }

    NoteEditorState.newNote(NotesFolderFS folder) {
        note = Note.newNote(folder);
    }

    NoteEditorState.fromNote(this.note) {
        originalNoteData = MdYamlDoc.from(note.data);
    }

    @override
    void initState() {
        super.initState();
        if (widget.defaultEditorType != null) {
            editorType = widget.defaultEditorType;
        } else {
            editorType = EditorType.Raw;
        }
    }

    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
                return true;
            },
            child: _getEditor(),
        );
    }

    // Private helpers

    Widget _getEditor() {
        return MarkdownEditor(
            key: _markdownEditorKey,
            note: note,
            exitEditorSelected: _exitEditorSelected,
        );
    }


    void _exitEditorSelected(Note note) {
        Navigator.pop(context);
    }
}
