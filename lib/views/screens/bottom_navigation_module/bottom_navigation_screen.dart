// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/views/screens/account_module/account_screen.dart';
import 'package:nectar_app/views/screens/cart_module/cart_screen.dart';
import 'package:nectar_app/views/screens/explore_module/explore_screen.dart';
import 'package:nectar_app/views/screens/favourite_module/favourite_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nectar_app/views/screens/home_module/home_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? isClose = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.areYouSure,
            ),
            content: Text(
              AppLocalizations.of(context)!.doYouWantCloseTheApp,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  AppLocalizations.of(context)!.no,
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  AppLocalizations.of(context)!.yes,
                ),
              ),
            ],
          ),
        );

        return isClose ?? false;
      },
      child: Scaffold(
        body: <Widget>[
          const HomeScreen(),
          const ExploreScreen(),
          const CartScreen(),
          const FavouriteScreen(),
          const AccountScreen(),
        ][_selectedIndex],
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  Widget get bottomNavigationBar {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0,
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag_outlined),
              label: AppLocalizations.of(context)!.shop,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: AppLocalizations.of(context)!.explore,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              label: AppLocalizations.of(context)!.cart,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border),
              label: AppLocalizations.of(context)!.favourite,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_outlined),
              label: AppLocalizations.of(context)!.account,
            ),
          ],
          unselectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: Globals.greenColor,
          onTap: (int index) {
            setState(
              () {
                _selectedIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}
