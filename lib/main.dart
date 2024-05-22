import 'package:flutter/material.dart';
import 'package:healthcare_management_system/models/authModel.dart';
import 'package:healthcare_management_system/screens/doctorDetails.dart';
import 'package:healthcare_management_system/screens/home.dart';
import 'package:healthcare_management_system/screens/loginPage.dart';
import 'package:healthcare_management_system/screens/payment.dart';
import 'package:healthcare_management_system/screens/registerPage.dart';
import 'package:healthcare_management_system/screens/createappointment.dart';
import 'package:healthcare_management_system/screens/settings.dart';
import 'package:healthcare_management_system/screens/startScreen.dart';
import 'package:healthcare_management_system/screens/success.dart';
import 'package:healthcare_management_system/screens/symptoms.dart';
import 'package:healthcare_management_system/utils/config.dart';
import 'package:healthcare_management_system/layout.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Config.primaryColor,
            border: Config.outlinedBorder,
            focusedBorder: Config.focusBorder,
            errorBorder: Config.errorBorder,
            enabledBorder: Config.outlinedBorder,
            floatingLabelStyle: TextStyle(color: Config.primaryColor),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Config.primaryColor,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          "login": (context) => LoginPage(),
          "register": (context) => RegisterPage(),
          'home': (context) => const Home(),
          'home': (context) => const Layout(),
          'symptoms': (context) => Symptoms(
                symptomName: '',
              ),
          'doctor': (context) => const DoctorDetails(),
          'schedule': (context) => const AppointmentMakingPage(),
          'payment': (context) => const Payment(),
          'success': (context) => const Success(),
          'settings': (context) => Settings(),
        },
      ),

      // initialRoute: '/',
      // routes: {
      //   '/':(context) => SplashScreen(),
      //     "login": (context) => LoginPage(),
      //     "register": (context) => RegisterPage(),
      //     'home':(context) => const Home(),
      //     'home':(context) => const Layout(),
      //     'symptoms': (context) => Symptoms(symptomName: '',),
      //     'doctor': (context) => const DoctorDetails(),
      //     'schedule': (context) => const Schedule(),
      //     'payment': (context) => const Payment(),
      //     'success': (context) => const Success(),
      //     'settings': (context) => Settings(),
      // },
      //home: const Home(),
    );
  }
}
