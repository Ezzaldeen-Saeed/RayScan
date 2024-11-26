import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testnav/main.dart';
import 'package:testnav/Storage/hiveManager.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/screens/addPatient_screen.dart';
import 'package:testnav/screens/home_screen.dart';
import 'package:testnav/screens/profile_screen.dart';
import 'package:testnav/screens/search_screen.dart';
import 'package:testnav/widgets/colors.dart';

import '../views/signup_login/login_view.dart';
import '../views/signup_login/signup_view.dart';

class UtilityManager {
  // Method to navigate to login screen
  static void goToLogin(BuildContext context) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => const LoginScreen(),
        settings: RouteSettings(name: "LoginPage")
    ),
  );
  static void goToSignup(BuildContext context) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => SignupScreen(),
      settings: RouteSettings(name: "SignupPage"),
    ),
  );

  // Method to navigate to home screen
  static void goToHome(BuildContext context) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(),
      settings: RouteSettings(name: "HomePage"),
    ),
  );

  // Method to navigate to add patient screen
  static void goToAddPatient(BuildContext context) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => AddPatientScreen(),
      settings: RouteSettings(name: "AddPatientPage"),
    ),
  );

  // Method to navigate to search screen
  static void goToSearch(BuildContext context) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => SearchScreen(),
      settings: RouteSettings(name: "SearchPage"),
    ),
  );

  // Method to navigate to profile screen
  static void goToProfile(BuildContext context) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ProfileScreen(),
      settings: RouteSettings(name: "ProfilePage"),
    ),
  );
}

class DarkModeController extends ChangeNotifier {
  bool _isDarkMode = darkMode;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    darkMode = _isDarkMode;
    hs.setDarkMode(darkMode);
    setCurrentTheme(darkMode);
    notifyListeners();
  }

  void setCurrentTheme(bool isDarkMode) {
    currentBG = isDarkMode ? darkModeBG1 : lightModeBG1;
    currentBG2 = isDarkMode ? darkModeBG2 : lightModeBG2;
    currentTextColor = isDarkMode ? textColorDarkMode : textColorLightMode;
  }
}

class SignUpAndLogin{
  final _auth = AuthService();

  signup(BuildContext context, String name, String email, String password) async {
    final user =
    await _auth.createUserWithEmailAndPassword(name, email, password);
    if (user != null) {
      log("User Created Succesfully");
      login(context, email, password);
      UtilityManager.goToHome(context);
    }
  }

  login(BuildContext context,String email, String password) async {
    final user =
    await _auth.loginUserWithEmailAndPassword(email, password);

    if (user != null) {
      log("User Logged In");
      HiveService().setLoginStatus(true);
      Map data = await _auth.getCurrentUserData();
      String name = data['name'];
      String profileImagePath = data['profileImagePath'];
      HiveService().saveUserData(name, email, profileImagePath);
      UtilityManager.goToHome(context);
    }
  }

  signOut(BuildContext context) async {
    await _auth.signout();
    HiveService().setLoginStatus(false);
    HiveService().clearUserData();
    HiveService().clearAppCache();
    UtilityManager.goToLogin(context);
  }
}