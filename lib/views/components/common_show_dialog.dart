import 'package:flutter/material.dart';

class CommonShowDialog {
  static show({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
