import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'folder_view.dart';
import 'folder_tree_view.dart';
import 'package:til/base/notes_folder_fs.dart';
import 'package:til/state/state_container.dart';
import 'package:til/state/app_state.dart';

class FolderListingScreen extends StatefulWidget {
    @override
    _FolderListingScreenState createState() => _FolderListingScreenState();
}

class _FolderListingScreenState extends State<FolderListingScreen> {
    final _folderTreeViewKey = GlobalKey<FolderTreeViewState>();
    NotesFolderFS selectedFolder;

    @override
    Widget build(BuildContext context) {
        final notesFolder = Provider.of<NotesFolderFS>(context);
        final stateContainer = Provider.of<StateContainer>(context);

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
            onFolderSelected: (folder) {
                setState(() {
                    selectedFolder = folder;
                });
            },
            onFolderUnselected: () {
                setState(() {
                    selectedFolder = null;
                });
            },
        );

        Widget action;
        if (selectedFolder != null) {
            action = PopupMenuButton(
                itemBuilder: (context) {
                    return [
                        const PopupMenuItem<String>(
                            child: Text("Rename Folder"),
                            value: "Rename",
                        ),
                        const PopupMenuItem<String>(
                            child: Text("Create Sub-Folder"),
                            value: "Create",
                        ),
                        const PopupMenuItem<String>(
                            child: Text("Delete Folder"),
                            value: "Delete",
                        ),
                    ];
                },
                onSelected: (String value) async {
                    /*if (value == "Rename") {
                        var folderName = await showDialog(
                            context: context,
                            builder: (_) => RenameDialog(
                                oldPath: selectedFolder.folderPath,
                                inputDecoration: 'Folder Name',
                                dialogTitle: "Rename Folder",
                            ),
                        );
                        if (folderName is String) {
                            var container =
                            Provider.of<StateContainer>(context, listen: false);
                            container.renameFolder(selectedFolder, folderName);
                        }
                    } else if (value == "Create") {
                        var folderName = await showDialog(
                            context: context,
                            builder: (_) => CreateFolderAlertDialog(),
                        );
                        if (folderName is String) {
                            var container =
                            Provider.of<StateContainer>(context, listen: false);
                            container.createFolder(selectedFolder, folderName);
                        }
                    } else if (value == "Delete") {
                        if (selectedFolder.hasNotesRecursive) {
                            await showDialog(
                                context: context,
                                builder: (_) => FolderErrorDialog(),
                            );
                        } else {
                            var container =
                            Provider.of<StateContainer>(context, listen: false);
                            container.removeFolder(selectedFolder);
                        }
                    }

                    _folderTreeViewKey.currentState.resetSelection();*/
                },
            );
        }

        var title = const Text("Folders");
        if (selectedFolder != null) {
            title = const Text("Folder Selected");
        }

        return Scaffold(
            appBar: AppBar(
                title: title,
                actions: <Widget>[
                    RaisedButton(
                        child: Text('Reset'),
                        onPressed: () {
                            stateContainer.reset();
                        },
                    )
                ],
            ),
            body: Scrollbar(child: treeView),
        );
    }
}
