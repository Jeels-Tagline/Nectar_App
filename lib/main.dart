import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nectar_app/l10n/l10n.dart';
import 'package:nectar_app/models/globals/globals.dart';
import 'package:nectar_app/models/hive_product_models.dart';
import 'package:nectar_app/navigator.dart';
import 'package:nectar_app/utils/font_family.dart';
import 'package:nectar_app/utils/language_path.dart';
import 'package:nectar_app/utils/screens_path.dart';
import 'package:nectar_app/views/screens/account_module/account_screen.dart';
import 'package:nectar_app/views/screens/bottom_navigation_module/bottom_navigation_screen.dart';
import 'package:nectar_app/views/screens/cart_module/cart_screen.dart';
import 'package:nectar_app/views/screens/explore_module/explore_product_screen.dart';
import 'package:nectar_app/views/screens/explore_module/explore_screen.dart';
import 'package:nectar_app/views/screens/favourite_module/favourite_screen.dart';
import 'package:nectar_app/views/screens/explore_module/filter_screen.dart';
import 'package:nectar_app/views/screens/auth_module/forgot_password_screen.dart';
import 'package:nectar_app/views/screens/location_module/get_location_screen.dart';
import 'package:nectar_app/views/screens/cart_module/order_accepted_screen.dart';
import 'package:nectar_app/views/screens/account_module/orders_screen.dart';
import 'package:nectar_app/views/screens/account_module/particular_order_screen.dart';
import 'package:nectar_app/views/screens/home_module/product_detail_screen.dart';
import 'package:nectar_app/views/screens/location_module/location_screen.dart';
import 'package:nectar_app/views/screens/auth_module/number_screen.dart';
import 'package:nectar_app/views/screens/home_module/home_screen.dart';
import 'package:nectar_app/views/screens/auth_module/login_screen.dart';
import 'package:nectar_app/views/screens/auth_module/number_verification_screen.dart';
import 'package:nectar_app/views/screens/onbording_module/onbording_screen.dart';
import 'package:nectar_app/views/screens/explore_module/search_screen.dart';
import 'package:nectar_app/views/screens/auth_module/signin_screen.dart';
import 'package:nectar_app/views/screens/auth_module/signup_screen.dart';
import 'package:nectar_app/views/screens/onbording_module/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

SharedPreferences? sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  sharedPreferences = await SharedPreferences.getInstance();

  await Hive.initFlutter();

  // Register Adapter
  Hive.registerAdapter(HiveProductModelAdapter());

  // Openbox & Create boxfile
  Globals.boxListOfProduct = await Hive.openBox<List>('listOfProductBox');
  Globals.boxCart = await Hive.openBox<List<Map<String, dynamic>>>('cartBox');

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

  runApp(const MyNectarApp());
}

class MyNectarApp extends StatefulWidget {
  const MyNectarApp({super.key});

  @override
  State<MyNectarApp> createState() => _MyNectarAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyNectarAppState? state =
        context.findAncestorStateOfType<_MyNectarAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyNectarAppState extends State<MyNectarApp> {
  Locale? myLocale;

  setLocale(Locale locale) {
    setState(() {
      myLocale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    LanguagePath.getLanguage().then((locale) => setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: L10n.all,
      locale: myLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
        ScreensPath.bottomNavigationScreen: (context) =>
            const BottomNavigationScreen(),
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
    );
  }
}


// TODO : check cart product are not open and also favourite product