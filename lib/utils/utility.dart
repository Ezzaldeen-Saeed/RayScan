import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/Storage/hiveManager.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/colors.dart';

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

class SignUpAndLogin {
  final _auth = AuthService();

  Future<bool> signup(BuildContext context, String firstName, String lastName,
      String email, String password) async {
    final user = await _auth.createUserWithEmailAndPassword(
        firstName, lastName, email, password);
    if (user != null) {
      log("User Created Succesfully");
      login(context, email, password);
      return true;
    }
    return false;
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    final user = await _auth.loginUserWithEmailAndPassword(email, password);

    if (user != null) {
      log("User Logged In");
      HiveService().setLoginStatus(true);
      Map data = await _auth.getCurrentUserData();
      String fName = data['userFirstName'];
      String lName = data['userLastName'];
      String profileImagePath = data['profileImagePath'];
      HiveService().saveUserData(fName, lName, email, profileImagePath);
      context.go('/home');
      return true;
    }
    return false;
  }

  Future<bool> signOut(BuildContext context) async {
    await _auth.signout();
    HiveService().setLoginStatus(false);
    HiveService().clearUserData();
    HiveService().clearAppCache();
    context.go('/login');
    return true;
  }
}