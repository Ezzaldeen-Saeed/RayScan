import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/widgets/BottomNavBar.dart';
import 'package:testnav/widgets/miniPatientCard.dart';
import 'package:testnav/widgets/miniProfileCard.dart';
import 'package:testnav/main.dart';

class HomeScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  SignUpAndLogin signupLogin = SignUpAndLogin();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the global controller
    final darkModeController = Provider.of<DarkModeController>(context);

    return Scaffold(
      backgroundColor: currentBG,
      body: Align(
        alignment: Alignment.center,
        child: ListView(
          children: [
            miniProfileCard(onPressed: () {
              darkModeController.toggleDarkMode();
            }),
            const SizedBox(height: 20),
            miniPatientCard(),
            const SizedBox(height: 20),
            CustomButton(
              label: "Sign Out",
              onPressed: () async {
                signupLogin.signOut(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(1),
    );
  }
}
