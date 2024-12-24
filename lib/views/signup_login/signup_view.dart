import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/utils/utility.dart';
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
    if (_firstName.text.trim().isEmpty) {
      _showSnackbar("First name is required", Colors.orange,
          icon: Icons.warning);
      return;
    }

    if (!RegExp(r"^[A-Za-z][A-Za-z\s]{2,}$").hasMatch(_firstName.text.trim())) {
      _showSnackbar(
          "First name must have at least 3 characters and cannot start with a number.",
          Colors.orange,
          icon: Icons.warning);
      return;
    }

    if (_lastName.text.trim().isEmpty) {
      _showSnackbar("Last name is required", Colors.orange,
          icon: Icons.warning);
      return;
    }

    if (!RegExp(r"^[A-Za-z][A-Za-z\s]{2,}$").hasMatch(_lastName.text.trim())) {
      _showSnackbar(
          "Last name must have at least 3 characters and cannot start with a number.",
          Colors.orange,
          icon: Icons.warning);
      return;
    }

    if (_email.text.trim().isEmpty) {
      _showSnackbar("Email is required", Colors.orange, icon: Icons.warning);
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(_email.text.trim())) {
      _showSnackbar("Please enter a valid email", Colors.orange,
          icon: Icons.warning);
      return;
    }

    if (_password.text.trim().isEmpty) {
      _showSnackbar("Password is required", Colors.orange, icon: Icons.warning);
      return;
    }

    if (!RegExp(
            r"^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*\-_])[A-Za-z\d!@#\$%\^&\*\-_]{8,}$")
        .hasMatch(_password.text.trim())) {
      _showSnackbar(
        "Password must be at least 8 characters long, include a number, an uppercase letter, and a special character.",
        Colors.orange,
        icon: Icons.warning,
      );
      print("Password entered: ${_password.text.trim()}");

      return;
    }

    setState(() {
      _isSigningUp = true;
    });

    try {
      final success = await signupLogin.signup(
        context,
        _firstName.text.trim(),
        _lastName.text.trim(),
        _email.text.trim(),
        _password.text.trim(),
      );

      if (!success) {
        _showSnackbar("Signup failed. Please try again.", Colors.red,
            icon: Icons.error);
      } else {
        _showSnackbar("Signup Successful", Colors.green,
            icon: Icons.check_circle);
        context.go('/login');
      }
    } catch (e) {
      print("Error during signup: $e");
      _showSnackbar(
          "An unexpected error occurred. Please try again.", Colors.red,
          icon: Icons.error_outline);
    } finally {
      setState(() {
        _isSigningUp = false;
      });
    }
  }

// دالة لعرض Snackbar محسّن
  void _showSnackbar(String message, Color backgroundColor, {IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
