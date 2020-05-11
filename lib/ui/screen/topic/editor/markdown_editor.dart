import 'package:flutter/material.dart';

import 'package:til/core/note.dart';
import 'package:til/settings/settings.dart';
import 'package:til/ui/widget/note_viewer.dart';

import 'common.dart';
import 'note_title_editor.dart';

class MarkdownEditor extends StatefulWidget implements Editor {
    final Note note;

    @override
    final NoteCallback exitEditorSelected;

    MarkdownEditor({
        Key key,
        @required this.note,
        @required this.exitEditorSelected,
    }) : super(key: key);

    @override
    MarkdownEditorState createState() {
        return MarkdownEditorState(note);
    }
}

class MarkdownEditorState extends State<MarkdownEditor> implements EditorState {
    Note note;
    TextEditingController _textController = TextEditingController();
    TextEditingController _titleTextController = TextEditingController();

    bool editingMode = true;

    MarkdownEditorState(this.note) {
        _textController = TextEditingController(text: note.body);
        _titleTextController = TextEditingController(text: note.title);

        editingMode = Settings.instance.markdownDefaultView == SettingsMarkdownDefaultView.Edit;
    }

    @override
    void dispose() {
        _textController.dispose();
        _titleTextController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        var editor = Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                        NoteTitleEditor(
                            _titleTextController,
                            _noteTextChanged,
                        ),
                        _NoteBodyEditor(
                            textController: _textController,
                            onChanged: _noteTextChanged,
                        ),
                    ],
                ),
            ),
        );

        Widget body = editingMode ? editor : NoteViewer(note: note);

        return Scaffold(
            appBar: buildEditorAppBar(
                widget,
                this,
            ),
            body: body,
        );
    }

    void _noteTextChanged() {
        // Do nothing for now
    }

    @override
    Note getNote() {
        return note;
    }
}

class _NoteBodyEditor extends StatelessWidget {
    final TextEditingController textController;
    final Function onChanged;

    _NoteBodyEditor({
        @required this.textController,
        @required this.onChanged,
    });

    @override
    Widget build(BuildContext context) {
        var style = Theme.of(context).textTheme.subhead;

        return TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: style,
            decoration: const InputDecoration(
                hintText: 'Write here',
                border: InputBorder.none,
                isDense: true,
            ),
            controller: textController,
            textCapitalization: TextCapitalization.sentences,
            scrollPadding: const EdgeInsets.all(0.0),
            onChanged: (_) => onChanged(),
        );
    }
}
