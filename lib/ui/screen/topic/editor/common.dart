import 'package:flutter/material.dart';
import 'package:til/base/note.dart';

typedef NoteCallback = void Function(Note);

abstract class Editor {
    NoteCallback get exitEditorSelected;
    NoteCallback get discardChangesSelected;
}

abstract class EditorState {
    Note getNote();
}

enum DropDownChoices { DiscardChanges }

AppBar buildEditorAppBar(
    Editor editor,
    EditorState editorState, {
        @required bool noteModified,
        List<IconButton> extraButtons,
    }) {
    return AppBar(
        leading: IconButton(
            key: const ValueKey("NewEntry"),
            icon: Icon(noteModified ? Icons.check : Icons.close),
            onPressed: () {
                print("Should EXIT");
                editor.exitEditorSelected(editorState.getNote());
            },
        ),
        actions: <Widget>[
            ...?extraButtons,
            PopupMenuButton<DropDownChoices>(
                onSelected: (DropDownChoices choice) {
                    switch (choice) {
                        case DropDownChoices.DiscardChanges:
                            var note = editorState.getNote();
                            editor.discardChangesSelected(note);
                            return;
                    }
                },
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<DropDownChoices>>[
                    const PopupMenuItem<DropDownChoices>(
                        value: DropDownChoices.DiscardChanges,
                        child: Text('Discard Changes'),
                    ),
                ],
            ),
        ],
    );
}
