import 'package:flutter/material.dart';

import 'package:til/base/note.dart';
import 'note_editor.dart';

void openNoteEditor(BuildContext context, Note note) async {
    var route = MaterialPageRoute(
        builder: (context) => NoteEditor.fromNote(note),
    );
    var showUndoSnackBar = await Navigator.of(context).push(route);
}
