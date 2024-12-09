import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testnav/Storage/hiveManager.dart';
import 'package:testnav/navigation/app_navigation.dart';
import 'package:testnav/utils/splashScreen.dart';
import 'package:testnav/widgets/pallet.dart';

// Hive Service
final HiveService hs = HiveService();

Color currentBG = lightModeBG1;
Color currentBG2 = lightModeBG2;
Color currentTextColor = textColorLightMode;

bool darkMode = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Firebase.initializeApp();

  await hs.setupApp();
  await AppNavigation.setInitial();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen Example',
      debugShowCheckedModeBanner: false,
      home: const Splashscreen(nextScreen: AppNavigator()),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Go Router Example',
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}
