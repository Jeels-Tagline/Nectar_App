import 'package:flutter/material.dart';
import 'package:nectar_app/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePath {
  static const String english = 'en';
  static const String gujarati = 'gu';
  static const String urdu = 'ur';
  static String appLanguage = '';
  static const String isLanguage = 'isLanguage';

  static Future<Locale> getLanguage() async {
    String language = sharedPreferences!.getString(isLanguage) ?? english;
    return locale(language);
  }

  static Locale locale(String language) {
    switch (language) {
      case english:
        return const Locale(english);
      case gujarati:
        return const Locale(gujarati);
      case urdu:
        return const Locale(urdu);
      default:
        return const Locale(english);
    }
  }

  AppLocalizations translation(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
