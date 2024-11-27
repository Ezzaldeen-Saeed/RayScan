import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  SignUpAndLogin signupLogin = SignUpAndLogin();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text(
                "Login",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500
                )
            ),
            const SizedBox(height: 50),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              controller: _password,
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Login",
              onPressed: () {
                signupLogin.login(
                  context,
                  _email.text.trim(),
                  _password.text.trim(),
                );
              },
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => context.go('/signup'),
                  child: const Text(
                    "Signup",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
