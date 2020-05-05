import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'list_view.dart';

import 'package:til/base/note.dart';
import 'package:til/base/notes_folder.dart';


class StandardView extends StatelessWidget {
    final NoteSelectedFunction noteSelectedFunction;
    final NotesFolder folder;
    final String emptyText;

    static final _dateFormat = DateFormat('dd MMM, yyyy');

    StandardView({
        @required this.folder,
        @required this.noteSelectedFunction,
        @required this.emptyText,
    });

    @override
    @override
    Widget build(BuildContext context) {
        return FolderListView(
            folder: folder,
            emptyText: emptyText,
            noteTileBuilder: _buildRow,
        );
    }

    Widget _buildRow(BuildContext context, Note note) {
        var textTheme = Theme.of(context).textTheme;

        String title = note.title;
        Widget titleWidget = Text(
            title,
            style: textTheme.title,
            overflow: TextOverflow.ellipsis,
        );
        Widget trailing = Container();

        DateTime date = note.created;
        if (date != null) {
            var dateStr = _dateFormat.format(date);
            trailing = Text(dateStr, style: textTheme.caption);
        }

        var titleRow = Row(
            children: <Widget>[Expanded(child: titleWidget), trailing],
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
        );

        ListTile tile = ListTile(
            isThreeLine: false,
            title: titleRow,
            onTap: () => noteSelectedFunction(note),
        );

        var dc = Theme.of(context).dividerColor;
        var divider = Container(
            height: 1.0,
            child: Divider(color: dc.withOpacity(dc.opacity / 3)),
        );

        return Column(
            children: <Widget>[
                divider,
                tile,
                divider,
            ],
        );
    }
}
