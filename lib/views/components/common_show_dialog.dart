import 'package:flutter/material.dart';

class CommonShowDialog {
  // bool dismissible = false;
  static show({required BuildContext context, bool? dismissible}) {
    showDialog(
      context: context,
      barrierDismissible: dismissible ?? false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Loading'),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  static close({required BuildContext context}) {
    Navigator.pop(context);
  }
}
