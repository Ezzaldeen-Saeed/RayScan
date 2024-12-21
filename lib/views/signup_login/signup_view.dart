import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/textfield.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  SignUpAndLogin signupLogin = SignUpAndLogin();
  bool _isSigningUp = false; // Track signup state

  @override
  void dispose() {
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
  }

  Future<void> _handleSignup() async {
    setState(() {
      _isSigningUp = true;
    });

    final success = await signupLogin.signup(
      context,
      _firstName.text.trim(),
      _lastName.text.trim(),
      _email.text.trim(),
      _password.text.trim(),
    );

    if (!success) {
      // Handle signup failure (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed. Please try again.'),
          backgroundColor: errorSnackBarBG,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup Successful'),
          backgroundColor: successSnackBarBG,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Spacer(),
              const Text("Signup",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
              const SizedBox(height: 50),
              CustomTextField(
                hint: "Enter First Name",
                label: "First Name",
                controller: _firstName,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Enter Last Name",
                label: "Last Name",
                controller: _lastName,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Enter Email",
                label: "Email",
                controller: _email,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Enter Password",
                label: "Password",
                isPassword: true,
                controller: _password,
              ),
              const SizedBox(height: 30),
              CustomButton(
                label: "Signup",
                isDisabled: _isSigningUp, // Disable button during signup
                onPressed: _isSigningUp ? null : _handleSignup,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  InkWell(
                    onTap: () => context.go('/login'),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
