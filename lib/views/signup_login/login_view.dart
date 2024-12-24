import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/views/signup_login/forgetPass_view.dart';
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

  int _loginAttempts = 0;
  bool _isBlocked = false;
  DateTime? _blockEndTime;

  Future<void> _handleLogin() async {
    if (_isBlocked && _blockEndTime != null) {
      final remainingTime = _blockEndTime!.difference(DateTime.now());
      if (!remainingTime.isNegative) {
        _showSnackbar(
          "Too many attempts. Try again in ${remainingTime.inSeconds} seconds.",
          Colors.red,
          icon: Icons.timer,
        );
        return;
      } else {
        _isBlocked = false;
        _loginAttempts = 0;
      }
    }

    if (_email.text.trim().isEmpty || _password.text.trim().isEmpty) {
      _showSnackbar(
        "Please fill all fields",
        Colors.orange,
        icon: Icons.warning,
      );
      return;
    }

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
        _loginAttempts++;
        if (_loginAttempts >= 3) {
          _isBlocked = true;
          _blockEndTime = DateTime.now().add(Duration(seconds: 30));
          _showSnackbar(
            "Too many failed attempts. Please wait 30 seconds before trying again.",
            Colors.red,
            icon: Icons.lock,
          );
          return;
        }
        _showSnackbar(
          "Invalid email or password",
          Colors.red,
          icon: Icons.error,
        );
      } else {
        _loginAttempts = 0;
        _showSnackbar(
          "Login Successful",
          Colors.green,
          icon: Icons.check_circle,
        );
        context.go('/home');
      }
    } catch (e) {
      print("Error during login: $e");
      _showSnackbar(
        "An unexpected error occurred. Please try again!!!!!!!.",
        Colors.red,
        icon: Icons.error_outline,
      );
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

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

// دالة لعرض SnackBar مخصصة بحجم ثابت وتصميم أفضل
  void _showCustomSnackBar(
      {required String message, required Color backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 80, // تثبيت حجم الـ SnackBar
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        // يجعل الـ SnackBar يظهر بشكل عائم
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: Colors.transparent,
        // شفافية الخلفية لتظهر الحاوية فقط
        duration: Duration(seconds: 3),
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
