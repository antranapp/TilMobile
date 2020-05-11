import 'package:flutter/material.dart';

import 'package:til/base/note.dart';
import 'package:til/settings/settings.dart';

import 'package:til/ui/widget/note_viewer.dart';

import 'common.dart';
import 'note_title_editor.dart';

class MarkdownEditor extends StatefulWidget implements Editor {
    final Note note;
    final bool noteModified;

    @override
    final NoteCallback exitEditorSelected;
    @override
    final NoteCallback discardChangesSelected;

    final bool isNewNote;

    MarkdownEditor({
        Key key,
        @required this.note,
        @required this.noteModified,
        @required this.exitEditorSelected,
        @required this.discardChangesSelected,
        @required this.isNewNote,
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
    bool _noteModified;

    MarkdownEditorState(this.note) {
        _textController = TextEditingController(text: note.body);
        _titleTextController = TextEditingController(text: note.title);

        editingMode = Settings.instance.markdownDefaultView == SettingsMarkdownDefaultView.Edit;
    }

    @override
    void initState() {
        super.initState();
        _noteModified = widget.noteModified;
        if (widget.isNewNote) {
            editingMode = true;
        }
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
                            autofocus: widget.isNewNote,
                            onChanged: _noteTextChanged,
                        ),
                    ],
                ),
            ),
        );

        Widget body = editingMode ? editor : NoteViewer(note: note);

        var extraButton = IconButton(
            icon: editingMode
                ? const Icon(Icons.remove_red_eye)
                : const Icon(Icons.edit),
            onPressed: _switchMode,
        );

        return Scaffold(
            appBar: buildEditorAppBar(
                widget,
                this,
                noteModified: _noteModified,
                extraButtons: [extraButton],
            ),
            body: body,
        );
    }

    void _switchMode() {
        setState(() {
            editingMode = !editingMode;
            _updateNote();
        });
    }

    void _updateNote() {
        note.title = _titleTextController.text.trim();
        note.body = _textController.text.trim();
    }

    @override
    Note getNote() {
        _updateNote();
        return note;
    }

    void _noteTextChanged() {
        if (_noteModified) return;
        setState(() {
            _noteModified = true;
        });
    }
}

class _NoteBodyEditor extends StatelessWidget {
    final TextEditingController textController;
    final bool autofocus;
    final Function onChanged;

    _NoteBodyEditor({
        @required this.textController,
        @required this.autofocus,
        @required this.onChanged,
    });

    @override
    Widget build(BuildContext context) {
        var style = Theme.of(context).textTheme.subhead;

        return TextField(
            autofocus: autofocus,
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
