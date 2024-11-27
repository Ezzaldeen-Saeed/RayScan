import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/utility.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final AuthService auth = AuthService();

  SignUpAndLogin signupLogin = SignUpAndLogin();

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
            Text("Search Page",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
