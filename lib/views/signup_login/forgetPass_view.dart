import 'package:email_validator/email_validator.dart';
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
  String _message = '';
  Color _messageColor = Colors.black;

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _message = "Please enter your email.";
        _messageColor = Colors.red;
      });
      return;
    }

    if (!EmailValidator.validate(email)) {
      setState(() {
        _message =
            "Invalid email format. Please enter a valid email (e.g., example@domain.com).";
        _messageColor = Colors.red;
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _message = "A reset link has been sent to $email.";
        _messageColor = Colors.green;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _message = "No account found for this email.";
          _messageColor = Colors.red;
        });
      } else if (e.code == 'too-many-requests') {
        setState(() {
          _message = "Too many attempts. Please try again later.";
          _messageColor = Colors.red;
        });
      } else {
        setState(() {
          _message = e.message ?? "An error occurred. Please try again.";
          _messageColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        _message =
            "An unexpected error occurred. Please check your connection and try again.";
        _messageColor = Colors.red;
      });
    }
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
