import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:til/utils/logger.dart';
import 'package:til/state/state_container.dart';

class AppDrawer extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        var stateContainer = Provider.of<StateContainer>(context);
        Widget setupGitButton;
        var appState = stateContainer.appState;
        var textStyle = Theme.of(context).textTheme.bodyText1;
        var currentRoute = ModalRoute.of(context).settings.name;

        if (!appState.remoteGitRepoConfigured) {
            setupGitButton = ListTile(
                leading: Icon(Icons.sync, color: textStyle.color),
                title: Text('Setup Git Host', style: textStyle),
                trailing: Icon(
                    Icons.info,
                    color: Colors.red,
                ),
                onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/setupRemoteGit");
                },
            );
        }

        var divider = Row(children: <Widget>[const Expanded(child: Divider())]);

        return Drawer(
            child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.only(top: 32.0),
                children: <Widget>[
                    if (setupGitButton != null) ...[setupGitButton, divider],
                    _buildDrawerTile(
                        context,
                        icon: Icons.folder,
                        title: "Folders",
                        onTap: () => _navTopLevel(context, '/folders'),
                        selected: currentRoute == "/folders",
                    ),
                    divider,
                    _buildDrawerTile(
                        context,
                        icon: Icons.settings,
                        title: 'Reset',
                        onTap: () {
                            showDialog(context: context, builder: _buildResetAlertDialog);
                        },
                    ),
                ],
            ),
        );
    }

    Widget _buildDrawerTile(
        BuildContext context, {
            @required IconData icon,
            @required String title,
            @required Function onTap,
            bool selected = false,
        }) {
        var theme = Theme.of(context);
        var listTileTheme = ListTileTheme.of(context);
        var textStyle = theme.textTheme.bodyText1.copyWith(
            color: selected ? theme.accentColor : listTileTheme.textColor,
        );

        var tile = ListTile(
            leading: Icon(icon, color: textStyle.color),
            title: Text(title, style: textStyle),
            onTap: onTap,
            selected: selected,
        );
        return Container(
            child: tile,
            color: selected ? theme.selectedRowColor : theme.scaffoldBackgroundColor,
        );
    }

    Widget _buildResetAlertDialog(BuildContext context) {
        return AlertDialog(
            title: Text("Confirmation"),
            content: Text("Do you want to reset the local til folder?"),
            actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Cancel"),
                ),
                FlatButton(
                    onPressed: () {
                        Provider.of<StateContainer>(context).reset();
                        _navTopLevel(context, '/setupRemoteGit');
                    },
                    child: Text("OK"),
                ),
            ],
        );
    }
}

void _navTopLevel(BuildContext context, String toRoute) {
    var fromRoute = ModalRoute.of(context).settings.name;
    Log.i("Routing from $fromRoute -> $toRoute");

    // Always first pop the AppBar
    Navigator.pop(context);

    if (fromRoute == toRoute) {
        return;
    }

    var wasParent = false;
    Navigator.popUntil(
        context,
        (route) {
            if (route.isFirst) {
                return true;
            }
            wasParent = route.settings.name == toRoute;
            if (wasParent) {
                Log.i("Router popping ${route.settings.name}");
            }
            return wasParent;
        },
    );
    if (!wasParent) {
        Navigator.pushNamed(context, toRoute);
    }
}
