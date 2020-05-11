import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:til/base/note.dart';
import 'package:til/base/md_yaml_doc.dart';
import 'package:til/base/notes_folder_fs.dart';
import 'package:til/state/state_container.dart';

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
            noteModified: _noteModified(note),
            exitEditorSelected: _exitEditorSelected,
            discardChangesSelected: _discardChangesSelected,
            isNewNote: _isNewNote,
        );
    }

    bool _noteModified(Note note) {
        if (_isNewNote) {
            return note.title.isNotEmpty || note.body.isNotEmpty;
        }

        if (note.data != originalNoteData) {
            var newSimplified = MdYamlDoc.from(note.data);
            newSimplified.props.remove(note.noteSerializer.settings.updatedAtKey);
            newSimplified.body = newSimplified.body.trim();

            var originalSimplified = MdYamlDoc.from(originalNoteData);
            originalSimplified.props.remove(note.noteSerializer.settings.updatedAtKey);
            originalSimplified.body = originalSimplified.body.trim();

            bool hasBeenModified = newSimplified != originalSimplified;
            if (hasBeenModified) {
                print("Note modified");
                print("Original: $originalSimplified");
                print("New: $newSimplified");
                return true;
            }
        }
        return false;
    }

    void _exitEditorSelected(Note note) {
        Navigator.pop(context);
    }

    Note _getNoteFromEditor() {
        return _markdownEditorKey.currentState.getNote();
    }

    void _discardChangesSelected(Note note) {
        if (_noteModified(note)) {
            showDialog(context: context, builder: _buildDiscardChangesAlertDialog);
        } else {
            Navigator.pop(context);
        }
    }

    Widget _buildDiscardChangesAlertDialog(BuildContext context) {
        var title = _isNewNote
            ? "Do you want to discard this?"
            : "Do you want to ignore the changes?";

        var editText = _isNewNote ? "Keep Writing" : "Keep Editing";
        var discardText = _isNewNote ? "Discard" : "Discard Changes";

        return AlertDialog(
            title: Text(title),
            actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(editText),
                ),
                FlatButton(
                    onPressed: () {
                        // FIXME: This shouldn't be required. Why is the original note modified?
                        note.data = originalNoteData;

                        Navigator.pop(context); // Alert box
                        Navigator.pop(context); // Note Editor
                    },
                    child: Text(discardText),
                ),
            ],
        );
    }
}
