import 'package:flutter/material.dart';

import 'package:function_types/function_types.dart';

import 'button.dart';
import 'key_editors.dart';

class GitUserProvidedSshKeys extends StatefulWidget {
    final Func2<String, String, void> doneFunction;

    GitUserProvidedSshKeys({
        @required this.doneFunction,
    });

    @override
    _GitUserProvidedSshKeysState createState() =>
        _GitUserProvidedSshKeysState();
}

class _GitUserProvidedSshKeysState extends State<GitUserProvidedSshKeys> {
    GlobalKey<FormState> _publicFormKey;
    GlobalKey<FormState> _privateFormKey;
    TextEditingController _publicKeyController;
    TextEditingController _privateKeyController;

    @override
    void initState() {
        super.initState();

        _publicFormKey = GlobalKey<FormState>();
        _privateFormKey = GlobalKey<FormState>();
        _publicKeyController = TextEditingController();
        _privateKeyController = TextEditingController();
    }

    @override
    void dispose() {
        _publicKeyController.dispose();
        _privateKeyController.dispose();

        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            child: Column(
                children: <Widget>[
                    Text(
                        "Public Key -",
                        style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 8.0),
                    PublicKeyEditor(_publicFormKey, _publicKeyController),
                    const SizedBox(height: 8.0),
                    Text(
                        "Private Key -",
                        style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 8.0),
                    PrivateKeyEditor(_privateFormKey, _privateKeyController),
                    const SizedBox(height: 16.0),
                    GitHostSetupButton(
                        text: "Next",
                        onPressed: () {
                            var publicValid = _publicFormKey.currentState.validate();
                            var privateValid = _privateFormKey.currentState.validate();

                            if (!publicValid || !privateValid) {
                                return;
                            }

                            var publicKey = _publicKeyController.text.trim();
                            if (!publicKey.endsWith('\n')) {
                                publicKey += '\n';
                            }

                            var privateKey = _privateKeyController.text.trim();
                            if (!privateKey.endsWith('\n')) {
                                privateKey += '\n';
                            }

                            widget.doneFunction(publicKey, privateKey);
                        },
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
            ),
        );
    }
}