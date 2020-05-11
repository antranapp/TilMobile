import 'package:flutter/material.dart';

import 'package:til/core/note.dart';

typedef NoteCallback = void Function(Note);

abstract class Editor {
    NoteCallback get exitEditorSelected;
}

abstract class EditorState {
    Note getNote();
}

AppBar buildEditorAppBar(
    Editor editor,
    EditorState editorState, {
        List<IconButton> extraButtons,
    }) {
    return AppBar(
        leading: IconButton(
            key: const ValueKey("NewEntry"),
            icon: Icon(Icons.close),
            onPressed: () {
                editor.exitEditorSelected(editorState.getNote());
            },
        ),
    );
}
