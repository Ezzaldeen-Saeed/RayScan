import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/widgets/button.dart';

class AddPatientView extends StatefulWidget {
  const AddPatientView({super.key});

  @override
  State<AddPatientView> createState() => _AddPatientViewState();
}

class _AddPatientViewState extends State<AddPatientView> {
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
            CustomButton(
              label: "Sign Out",
              onPressed: () async {
                signupLogin.signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
