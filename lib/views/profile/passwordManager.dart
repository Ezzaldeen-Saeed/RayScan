import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/textfield.dart';

class Passwordmanager_subview extends StatefulWidget {
  const Passwordmanager_subview({super.key});

  @override
  State<Passwordmanager_subview> createState() =>
      _PasswordManagerSubviewState();
}

class _PasswordManagerSubviewState extends State<Passwordmanager_subview> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _auth.changePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password changed successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to change password!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: CustomText("Password Manager", 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildPasswordField(
                "Current Password",
                _currentPasswordController,
                "Enter your current password",
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                "New Password",
                _newPasswordController,
                "Enter a new password",
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                "Confirm New Password",
                _confirmNewPasswordController,
                "Confirm your new password",
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return "Passwords do not match!";
                  }
                  return null;
                },
              ),
              const Spacer(),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _changePassword(context),
                      child:
                          CustomText("Save Changes", 1.0, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    String hint, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        CustomTextFieldV2(
          type: 1.0,
          isPassword: true,
          controller: controller,
          // validator: validator ??
          //         (value) {
          //       if (value == null || value.isEmpty) {
          //         return "This field cannot be empty.";
          //       }
          //       return null;
          //     },
        ),
      ],
    );
  }
}
