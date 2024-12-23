import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/views/signup_login/forgetPass_view.dart';
import 'package:testnav/widgets/customSnackbar.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  late AnimationController _animationController;

  SignUpAndLogin signupLogin = SignUpAndLogin();
  bool _isLoggingIn = false; // Track login state

  @override
  void dispose() {
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
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    // Testing
    _email.text = "test@gmail.com";
    _password.text = "test1234";
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      final success = await signupLogin.login(
        context,
        _email.text.trim(),
        _password.text.trim(),
      );

      if (!success) {
        CustomSnackbar(
          title: 'Login failed. Please try again.',
          actionLabel: "Retry",
          backgroundColor: Colors.red,
          fontColor: Colors.white,
          hasAction: true,
          onPressAction: () {
            _handleLogin();
          },
        ).showUndo(context, 'patientId');
      } else {
        CustomSnackbar(
          title: 'Login Successful',
          actionLabel: "Go to Home",
          backgroundColor: Colors.green,
          fontColor: Colors.white,
          hasAction: true,
          onPressAction: () {
            context.go('/home');
          },
        ).show(context);
      }
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred. Please try again."),
          backgroundColor: errorSnackBarBG,
        ),
      );
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
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
                Hero(
                  tag: 'welcome_text',
                  child: Container(
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
                                angle:
                                    sin(_animationController.value * pi * 2) *
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
                ),
                const SizedBox(height: 10),
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/icon/App.png',
                    height: 220,
                    width: 250,
                  ),
                ),
                const SizedBox(height: 70),
                Hero(
                  tag: 'welcome_message',
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Welcome",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Hero(
                  tag: 'email_field',
                  child: CustomTextFieldV2(
                    hint: "example@example.com",
                    label: "Email or Mobile Number",
                    controller: _email,
                    type: 1,
                  ),
                ),
                const SizedBox(height: 20),
                Hero(
                  tag: 'password_field',
                  child: CustomTextFieldV2(
                    hint: "Enter Password",
                    label: "Password",
                    controller: _password,
                    isPassword: true,
                    type: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Hero(
                  tag: 'forget_password',
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => forgetPass_view())),
                      child: const Text(
                        "Forget Password",
                        style: TextStyle(color: Color(0xFF1B6283)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Hero(
                  tag: 'login_button',
                  child: Center(
                    child: SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoggingIn ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color(0xFF1B6283),
                        ),
                        child: _isLoggingIn
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Log In",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Hero(
                  tag: 'signup_redirect',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      InkWell(
                        onTap: () => context.go('/signup'),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Color(0xFF1B6283)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
