import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Today I Learned"),
            ),
            body: Scrollbar(
                child: FlatButton(
                    child: Text("Go to folder"),
                    onPressed: () => {
                        Navigator.of(context).pushNamed("/folders")
                    },
                ),
            ),
        );
    }

}