import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/widgets/BottomNavBar.dart';
import 'package:testnav/main.dart';

class SearchScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  SignUpAndLogin signupLogin = SignUpAndLogin();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the global controller
    return Scaffold(
      backgroundColor: currentBG,
      body: Align(
        alignment: Alignment.center,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text("Search Page", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(2),
    );
  }
}
