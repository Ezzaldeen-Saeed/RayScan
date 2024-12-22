import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/widgets/customSnackbar.dart';
import 'package:testnav/widgets/textfield.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView>
    with SingleTickerProviderStateMixin {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late AnimationController _animationController;

  SignUpAndLogin signupLogin = SignUpAndLogin();
  bool _isSigningUp = false; // Track signup state

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
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

    setState(() {
      _isSigningUp = false;
    });

    if (!success) {
      CustomSnackbar(
        title: 'Signup failed. Please try again.',
        actionLabel: "Retry",
        backgroundColor: Colors.red,
        fontColor: Colors.white,
        hasAction: true,
        onPressAction: _handleSignup,
      ).show(context);
    } else {
      CustomSnackbar(
        title: 'Signup Successful',
        actionLabel: "Go to Login",
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        hasAction: true,
        onPressAction: () {
          context.go('/login');
        },
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Hello! ",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: sin(_animationController.value * pi * 2) *
                                  0.2,
                              child: const Icon(
                                Icons.waving_hand,
                                color: Color(0xFF1B6283),
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Hero(
                  tag: 'logo', // Identifier for Hero animation
                  child: Image.asset(
                    'assets/icon/App.png',
                    height: 220,
                    width: 250,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextFieldV2(
                  hint: "Enter First Name",
                  label: "First Name",
                  controller: _firstName,
                  type: 1,
                ),
                const SizedBox(height: 20),
                CustomTextFieldV2(
                  hint: "Enter Last Name",
                  label: "Last Name",
                  controller: _lastName,
                  type: 1,
                ),
                const SizedBox(height: 20),
                CustomTextFieldV2(
                  hint: "Enter Email",
                  label: "Email",
                  controller: _email,
                  type: 1,
                ),
                const SizedBox(height: 20),
                CustomTextFieldV2(
                  hint: "Enter Password",
                  label: "Password",
                  isPassword: true,
                  controller: _password,
                  type: 1,
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSigningUp ? null : _handleSignup,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color(0xFF1B6283),
                      ),
                      child: _isSigningUp
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign Up",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    InkWell(
                      onTap: () => context.go('/login'),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Color(0xFF1B6283)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
