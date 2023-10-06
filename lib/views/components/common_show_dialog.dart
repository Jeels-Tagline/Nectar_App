import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonShowDialog {
  // bool dismissible = false;
  static show({required BuildContext context, bool? dismissible}) {
    showDialog(
      context: context,
      barrierDismissible: dismissible ?? false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.loading,
              ),
              const CircularProgressIndicator(),
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
