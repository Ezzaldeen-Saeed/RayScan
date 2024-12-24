import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testnav/widgets/textfield.dart';

class forgetPass_view extends StatefulWidget {
  const forgetPass_view({super.key});

  @override
  State<forgetPass_view> createState() => _ForgetPassViewState();
}

class _ForgetPassViewState extends State<forgetPass_view> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSendingResetLink = false;

  String _message = '';
  Color _messageColor = Colors.black;

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackbar(
        "Please enter your email.",
        Colors.orange,
        icon: Icons.warning,
      );
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      _showSnackbar(
        "Invalid email format. Please enter a valid email (e.g., example@domain.com).",
        Colors.red,
        icon: Icons.error,
      );
      return;
    }

    setState(() {
      _isSendingResetLink = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnackbar(
        "A reset link has been sent to $email.",
        Colors.green,
        icon: Icons.check_circle,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackbar(
          "No account found for this email.",
          Colors.red,
          icon: Icons.error_outline,
        );
      } else if (e.code == 'too-many-requests') {
        _showSnackbar(
          "Too many attempts. Please try again later.",
          Colors.orange,
          icon: Icons.timer,
        );
      } else {
        _showSnackbar(
          e.message ?? "An error occurred. Please try again.",
          Colors.red,
          icon: Icons.error,
        );
      }
    } catch (e) {
      _showSnackbar(
        "An unexpected error occurred. Please check your connection and try again.",
        Colors.red,
        icon: Icons.wifi_off,
      );
    } finally {
      setState(() {
        _isSendingResetLink = false;
      });
    }
  }

  void _showSnackbar(String message, Color backgroundColor, {IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null)
              Icon(icon, color: Colors.white, size: 20), // Icon for the message
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B6283)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Forget Password",
          style: TextStyle(
            color: Color(0xFF1B6283),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),

              // Description Text
              const Text(
                "Enter your email to receive a reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              // Styled Email Text Field
              Material(
                color: Colors.transparent,
                child: CustomTextFieldV2(
                  hint: "example@example.com",
                  label: "Email Address",
                  controller: _emailController,
                  type: 1,
                ),
              ),

              const SizedBox(height: 20),

              // Feedback Message
              if (_message.isNotEmpty)
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _messageColor, fontSize: 16),
                ),

              const SizedBox(height: 20),

              // Reset Password Illustration
              Image.asset(
                'assets/icon/Pass.png',
                height: 350,
                width: 500,
              ),

              const SizedBox(height: 30),

              // Send Reset Link Button
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: _sendResetLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6283),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    "Send Reset Link",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
