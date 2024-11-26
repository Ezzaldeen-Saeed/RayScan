import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testnav/navigation/app_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:testnav/views/signup_login/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testnav/Storage/hiveManager.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/widgets/colors.dart';

// Hive Service
final HiveService hs = HiveService();
final UtilityManager utili = UtilityManager();
final DarkModeController darkModeController = DarkModeController();

Color currentBG = lightModeBG1;
Color currentBG2 = lightModeBG2;
Color currentTextColor = textColorLightMode;

bool darkMode = false;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Firebase.initializeApp();

  // Await hs.setupApp before calling setCurrentTheme
  await hs.setupApp();
  log("Setup complete");

  // Now set the current theme
  darkModeController.setCurrentTheme(darkMode);
  log("Theme updated");

  // Continue with the rest of the app initialization
  runApp(
    ChangeNotifierProvider(
      create: (_) => DarkModeController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  Future<bool> isLoggedInFuture = hs.isLoggedIn();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Go Router Example',
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}
