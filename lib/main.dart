import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nectar_app/models/globals/boxes.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/hive_product_models.dart';
import 'package:nectar_app/navigator.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/screens/account_screen.dart';
import 'package:nectar_app/views/screens/cart_screen.dart';
import 'package:nectar_app/views/screens/explore_product_screen.dart';
import 'package:nectar_app/views/screens/explore_screen.dart';
import 'package:nectar_app/views/screens/favourite_screen.dart';
import 'package:nectar_app/views/screens/filter_screen.dart';
import 'package:nectar_app/views/screens/forgot_password_screen.dart';
import 'package:nectar_app/views/screens/get_location_screen.dart';
import 'package:nectar_app/views/screens/order_accepted_screen.dart';
import 'package:nectar_app/views/screens/orders_screen.dart';
import 'package:nectar_app/views/screens/particular_order_screen.dart';
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

  await Hive.initFlutter();

  // Register Adapter
  Hive.registerAdapter(HiveProductModelAdapter());
  // Hive.registerAdapter(HiveListProductModelAdapter());

  // Openbox & Create boxfile
  boxListOfProduct = await Hive.openBox<List>('listOfProductBox');
  boxCart = await Hive.openBox<List<Map<String, dynamic>>>('cartBox');

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error\n ${details.exception}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Globals.greenColor,
          fontSize: 20,
        ),
      ),
    );
  };

  runApp(
    MaterialApp(
      navigatorKey: NavKey.navKey,
      debugShowCheckedModeBanner: false,
      initialRoute: ScreensPath.splashScreen,
      theme: ThemeData(
        dialogBackgroundColor: Colors.green.shade50,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Globals.greenColor,
          primary: Globals.greenColor,
        ),
        fontFamily: FontFamily.bold,
      ),
      routes: {
        ScreensPath.splashScreen: (context) => const SplashScreen(),
        ScreensPath.onbordingScreen: (context) => const OnBordingScreen(),
        ScreensPath.logInScreen: (context) => const LoginScreen(),
        ScreensPath.numberScreen: (context) => const NumberScreen(),
        ScreensPath.numberVerificationScreen: (context) =>
            const NumberVerificationScreen(),
        ScreensPath.signInScreen: (context) => const SignInScreen(),
        ScreensPath.signUpScreen: (context) => const SignUpScreen(),
        ScreensPath.locationScreen: (context) => const LocationScreen(),
        ScreensPath.getLocationScreen: (context) => const GetLocationScreen(),
        ScreensPath.homeScreen: (context) => const HomeScreen(),
        ScreensPath.productDetailScreen: (context) =>
            const ProductDetailScreen(),
        ScreensPath.exploreScreen: (context) => const ExploreScreen(),
        ScreensPath.searchScreen: (context) => const SearchScreen(),
        ScreensPath.exploreProductScreen: (context) =>
            const ExploreProductScreen(),
        ScreensPath.cartScreen: (context) => const CartScreen(),
        ScreensPath.favouriteScreen: (context) => const FavouriteScreen(),
        ScreensPath.accountScreen: (context) => const AccountScreen(),
        ScreensPath.orderAcceptedScreen: (context) =>
            const OrderAcceptedScreen(),
        ScreensPath.ordersScreen: (context) => const OrdersScreen(),
        ScreensPath.forgotPasswordScreen: (context) =>
            const ForgotPasswordScreen(),
        ScreensPath.particularOrderScreen: (context) =>
            const ParticularOrderScreen(),
        ScreensPath.filterScreen: (context) => const FilterScreen(),
      },
    ),
  );
}
