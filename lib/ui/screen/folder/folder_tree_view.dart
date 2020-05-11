import 'package:flutter/material.dart';

import 'package:til/core/notes_folder_fs.dart';

typedef void FolderSelectedCallback(NotesFolderFS folder);

class FolderTreeView extends StatefulWidget {
    final NotesFolderFS rootFolder;

    final FolderSelectedCallback onFolderEntered;

    FolderTreeView({
        Key key,
        @required this.rootFolder,
        @required this.onFolderEntered,
    }) : super(key: key);

    @override
    FolderTreeViewState createState() => FolderTreeViewState();
}

class FolderTreeViewState extends State<FolderTreeView> {

    @override
    Widget build(BuildContext context) {
        var tile = FolderTile(
            folder: widget.rootFolder,
            onTap: (NotesFolderFS folder) {
                widget.onFolderEntered(folder);
            },
        );

        return ListView(
            children: <Widget>[tile],
        );
    }
}

class FolderTile extends StatefulWidget {
    final NotesFolderFS folder;
    final FolderSelectedCallback onTap;

    FolderTile({
        @required this.folder,
        @required this.onTap,
    });

    @override
    FolderTileState createState() => FolderTileState();
}

class FolderTileState extends State<FolderTile> {
    final MainAxisSize mainAxisSize = MainAxisSize.min;
    final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;
    final MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center;

    bool _isExpanded = true;

    @override
    Widget build(BuildContext context) {
        return Column(
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: <Widget>[
                GestureDetector(
                    child: _buildFolderTile(),
                    onTap: () => widget.onTap(widget.folder),
                ),
                _getChild(),
            ],
        );
    }

    Widget _buildFolderTile() {
        var folder = widget.folder;
        var ic = _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;
        var trailing = folder.hasSubFolders
            ? IconButton(
            icon: Icon(ic),
            onPressed: expand,
        )
            : null;

        var folderName = folder.name;
        if (folder.parent == null) {
            folderName = "TIL";
        }
        var subtitle = folder.numberOfNotes.toString() + " tils";

        final theme = Theme.of(context);

        return Card(
            child: ListTile(
                leading: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: Icon(
                        Icons.folder,
                        size: 36,
                        color: Theme.of(context).accentColor,
                    ),
                ),
                title: Text(folderName),
                subtitle: Text(subtitle),
                trailing: trailing,
            ),
            color: theme.cardColor,
        );
    }

    void expand() {
        setState(() {
            _isExpanded = !_isExpanded;
        });
    }

    Widget _getChild() {
        if (!_isExpanded) return Container();

        var children = <FolderTile>[];
        widget.folder.subFolders.forEach((folder) {
            children.add(FolderTile(
                folder: folder,
                onTap: widget.onTap,
            ));
        });

        return Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: Column(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: crossAxisAlignment,
                mainAxisSize: mainAxisSize,
                children: children,
            ),
        );
    }
}
