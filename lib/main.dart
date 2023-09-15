import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/navigator.dart';
import 'package:nectar_app/views/screens/account_screen.dart';
import 'package:nectar_app/views/screens/cart_screen.dart';
import 'package:nectar_app/views/screens/explore_product_screen.dart';
import 'package:nectar_app/views/screens/explore_screen.dart';
import 'package:nectar_app/views/screens/favourite_screen.dart';
import 'package:nectar_app/views/screens/get_location_screen.dart';
import 'package:nectar_app/views/screens/order_accepted_screen.dart';
import 'package:nectar_app/views/screens/product_detail_screen.dart';
import 'package:nectar_app/views/screens/location_screen.dart';
import 'package:nectar_app/views/screens/number_screen.dart';
import 'package:nectar_app/views/screens/home_screen.dart';
import 'package:nectar_app/views/screens/login_screen.dart';
import 'package:nectar_app/views/screens/number_verification_screen.dart';
import 'package:nectar_app/views/screens/onbording_screen.dart';
import 'package:nectar_app/views/screens/search_screen.dart';
import 'package:nectar_app/views/screens/signin_screen.dart';
import 'package:nectar_app/views/screens/signup_screen.dart';
import 'package:nectar_app/views/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    MaterialApp(
      navigatorKey: NavKey.navKey,
      debugShowCheckedModeBanner: false,
      initialRoute: 'splash_screen',
      theme: ThemeData(
        dialogBackgroundColor: Colors.green.shade50,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Globals.greenColor,
          primary: Globals.greenColor, //<-- SEE HERE
        ),
        fontFamily: 'Gilroy-Bold',
      ),
      routes: {
        'splash_screen': (context) => const SplashScreen(),
        'onbording_screen': (context) => const OnBordingScreen(),
        'login_screen': (context) => const LoginScreen(),
        'number_screen': (context) => const NumberScreen(),
        'number_verification_screen': (context) =>
            const NumberVerificationScreen(),
        'signin_screen': (context) => const SigninScreen(),
        'signup_screen': (context) => const SignupScreen(),
        'location_screen': (context) => const LocationScreen(),
        'get_location_screen': (context) => const GetLocationScreen(),
        'home_screen': (context) => const HomeScreen(),
        'product_detail_screen': (context) => const ProductDetailScreen(),
        'explore_screen': (context) => const ExploreScreen(),
        'search_screen': (context) => const SearchScreen(),
        'explore_product_screen': (context) => const ExploreProductScreen(),
        'cart_screen': (context) => const CartScreen(),
        'favourite_screen': (context) => const FavouriteScreen(),
        'account_screen': (context) => const AccountScreen(),
        'order_accepted_screen': (context) => const OrderAcceptedScreen(),
      },
    ),
  );
}
