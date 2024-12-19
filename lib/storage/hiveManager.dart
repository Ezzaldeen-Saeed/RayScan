import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/Utility.dart';

class HiveService {
  final String _boxName = 'myBox';

  Future<Box> get _box async => Hive.openBox(_boxName);

  // CRUD operations
  // Create
  Future<void> create(String value) async {
    final box = await _box;
    await box.add(value);
  }

  // Read
  Future<List<dynamic>> read() async {
    final box = await _box;
    return box.values.toList();
  }

  // Update
  Future<void> update(int index, String value) async {
    final box = await _box;
    await box.putAt(index, value);
  }

  // Delete
  Future<void> delete(int index) async {
    final box = await _box;
    await box.deleteAt(index);
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final box = await Hive.openBox('authBox');
    return box.get('isLoggedIn', defaultValue: false) == true;
  }

  // Set login status
  Future<void> setLoginStatus(bool status) async {
    final box = await Hive.openBox('authBox');
    await box.put('isLoggedIn', status);
  }

  // Save user data
  Future<void> saveUserData(String firstName, String lastName, String userEmail,
      String profileImagePath) async {
    final box = await Hive.openBox('userBox');
    await box.put('userFirstName', firstName);
    await box.put('userLastName', lastName);
    await box.put('userEmail', userEmail);
    await box.put('profileImagePath', profileImagePath);
  }

  Future<String> getUserFirstName() async {
    final box = await Hive.openBox('userBox');
    return box.get('userFirstName');
  }

  Future<String> getUserLastName() async {
    final box = await Hive.openBox('userBox');
    return box.get('userLastName');
  }

  Future<String> getUserEmail() async {
    final box = await Hive.openBox('userBox');
    return box.get('userEmail');
  }

  Future<String> getProfileImagePath() async {
    final box = await Hive.openBox('userBox');
    return box.get('profileImagePath') ??
        'assets/others/defaultProfileImage.png';
  }

  Future<void> setProfileImagePath(String path) async {
    final box = await Hive.openBox('userBox');
    await box.put('profileImagePath', path);
  }

  // Clear user data
  Future<void> clearUserData() async {
    final box = await Hive.openBox('userBox');
    await box.clear();
  }

  // Read patient data
  Future<Map<String, String?>> getLatestPatientData() async {
    final box = await Hive.openBox('patientData');
    return {
      'patientFirstName': box.get('patientFirstName'),
      'patientLastName': box.get('patientLastName'),
      'patientDOB': box.get('patientDOB'),
      'patientGender': box.get('patientGender'),
    };
  }

  // Setup the Application Cache
  Future<void> setupApp() async {
    final box = await Hive.openBox('appBox');
    darkMode = box.get('darkMode', defaultValue: false) == true;
    log("Initial Dark Mode: $darkMode");
  }

  // Set Dark Mode
  Future<void> setDarkMode(bool status) async {
    final box = await Hive.openBox('appBox');
    await box.put('darkMode', status);
    log("Change Dark Mode: $status");
  }

  // Get Dark Mode
  Future<bool> getDarkMode() async {
    final box = await Hive.openBox('appBox');
    return box.get('darkMode', defaultValue: false) == true;
  }

  // Clear App Cache
  Future<void> clearAppCache() async {
    final box = await Hive.openBox('appBox');
    await box.clear();
    DarkModeController darkModeController = DarkModeController();
    darkModeController.setCurrentTheme(false);
    darkMode = false;
    log("darkMode $darkMode");
    bool DarkMode = await getDarkMode();
    log("hive darkMode $DarkMode");
  }
}