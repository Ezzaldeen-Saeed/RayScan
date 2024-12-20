import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/Storage/hiveManager.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/pallet.dart';

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
      print("User Created Succesfully");
      context.go('/login');
      return true;
    }
    return false;
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    final user = await _auth.loginUserWithEmailAndPassword(email, password);

    if (user != null) {
      print("User Logged In");
      HiveService().setLoginStatus(true);
      Map data = await _auth.getCurrentUserData();
      String fName = data['userFirstName'];
      String lName = data['userLastName'];
      String profileImagePath = await HiveService().getProfileImagePath();
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

class RandomPatientGenerator {
  final List<String> firstNames = [
    'John',
    'Jane',
    'Michael',
    'Emily',
    'Chris',
    'Sarah',
    'David',
    'Anna'
  ];
  final List<String> lastNames = [
    'Smith',
    'Johnson',
    'Brown',
    'Williams',
    'Jones',
    'Miller',
    'Davis',
    'Garcia'
  ];
  final List<String> genders = ['Male', 'Female'];
  final Random random = Random();

  Map<String, dynamic> generateRandomPatient() {
    final String firstName = firstNames[random.nextInt(firstNames.length)];
    final String lastName = lastNames[random.nextInt(lastNames.length)];
    final String gender = genders[random.nextInt(genders.length)];
    final int age = random.nextInt(100); // Age between 0 and 99
    final String phone = List.generate(10, (_) => random.nextInt(10))
        .join(); // Generate 10-digit phone as string

    // Generate a valid random date for diagnosis
    final DateTime now = DateTime.now();
    final DateTime randomDate =
        now.subtract(Duration(days: random.nextInt(365 * 50))); // 50 years max
    final Timestamp diagnosisDate = Timestamp.fromDate(randomDate);

    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': DateTime(
          now.year - age, random.nextInt(12) + 1, random.nextInt(28) + 1),
      'gender': gender,
      'phone': phone,
      'age': age,
    };
  }
}
