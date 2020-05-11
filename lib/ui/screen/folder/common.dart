import 'package:flutter/material.dart';

import 'package:til/core/note.dart';
import 'note_editor_screen.dart';

void openNoteEditor(BuildContext context, Note note) async {
    var route = MaterialPageRoute(
        builder: (context) => NoteEditor.fromNote(note),
    );
    await Navigator.of(context).push(route);
}
