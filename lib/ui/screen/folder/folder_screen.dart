import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:til/core/notes_folder_fs.dart';
import 'package:til/ui/widget/app_drawer.dart';

import 'folder_view.dart';
import 'folder_tree_view.dart';

class FolderListingScreen extends StatefulWidget {
    @override
    _FolderListingScreenState createState() => _FolderListingScreenState();
}

class _FolderListingScreenState extends State<FolderListingScreen> {
    final _folderTreeViewKey = GlobalKey<FolderTreeViewState>();

    @override
    Widget build(BuildContext context) {
        final notesFolder = Provider.of<NotesFolderFS>(context);

        var treeView = FolderTreeView(
            key: _folderTreeViewKey,
            rootFolder: notesFolder,
            onFolderEntered: (NotesFolderFS folder) {
                print(folder.name);
                var route = MaterialPageRoute(
                    builder: (context) => FolderView(
                        notesFolder: folder,
                    ),
                );
                Navigator.of(context).push(route);
            },
        );

        var title = const Text("Folders");

        return Scaffold(
            appBar: AppBar(
                title: title,
            ),
            body: Scrollbar(child: treeView),
            drawer: AppDrawer(),
        );
    }
}
