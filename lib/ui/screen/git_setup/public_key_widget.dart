import 'package:flutter/material.dart';

class PublicKeyWidget extends StatelessWidget {
    final String publicKey;

    PublicKeyWidget(this.publicKey);
    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: double.infinity,
            height: 160.0,
            child: Container(
                color: Theme.of(context).buttonColor,
                child: SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            publicKey,
                            textAlign: TextAlign.left,
                            maxLines: null,
                            style: Theme.of(context).textTheme.body1,
                        ),
                    ),
                ),
            ),
        );
    }
}
