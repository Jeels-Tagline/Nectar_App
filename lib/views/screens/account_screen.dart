// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nectar_app/helpers/auth_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          FirebaseAuthHelper.firebaseAuthHelper.logOut();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);
          await prefs.setString('isUserID', '');
          Navigator.pushNamedAndRemoveUntil(
              context, 'onbording_screen', (route) => false);
        },
      ),
    );
  }
}
