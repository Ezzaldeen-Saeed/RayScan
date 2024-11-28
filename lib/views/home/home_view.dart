import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/miniPatientCard.dart';
import 'package:testnav/widgets/miniProfileCard.dart';

class HomeView extends StatelessWidget {
  final AuthService auth = AuthService();

  SignUpAndLogin signupLogin = SignUpAndLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentBG,
      body: Align(
        alignment: Alignment.center,
        child: ListView(
          children: [
            MiniProfileCard(onPressed: () {
              context.goNamed("Profile");
            }),
            const SizedBox(height: 20),
            miniPatientCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
