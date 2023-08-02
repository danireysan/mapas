import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CupertinoAlertDialog(
              title: const Text('Espere por favor'),
              content: Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.only(top: 10),
                child: const Column(
                  children: [
                    CupertinoActivityIndicator(),
                    SizedBox(height: 10),
                    Text('Calculando ruta'),
                  ],
                ),
              ),
            ));
    return;
  }
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _LoadingMessage(),
  );
}

class _LoadingMessage extends StatelessWidget {
  const _LoadingMessage();

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Espere por favor'),
      content: Column(
        children: [
          CircularProgressIndicator(),
          Text('Calculando ruta'),
        ],
      ),
    );
  }
}
