import 'package:flutter/material.dart';
import 'package:testnav/widgets/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.label,
    this.controller,
    this.isPassword = false,
    this.outLine = false,
    this.backgroundColor = lightModeBG1,
    this.focusedBorderColor = primaryColor,
    this.isIconed = false,
    this.icon,
    this.keyboardType,
  });

  final String hint;
  final String label;
  final bool isPassword;
  final bool outLine;
  final TextEditingController? controller;
  final Color backgroundColor; // Background color of the text field
  final Color focusedBorderColor; // Border color when the text field is focused
  final bool isIconed; // Determines if an icon is added
  final Icon? icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            blurRadius: 2, // How soft the shadow is
            offset: const Offset(0, 2), // Offset in x and y direction
          ),
        ],
      ),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(6),
        child: TextField(
          obscureText: isPassword,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: backgroundColor,
            // Sets the background color
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            label: Text(label),
            prefixIcon: isIconed ? icon : null,
            // Adds an icon if `isIconed` is true
            border: outLine
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  )
                : InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: focusedBorderColor,
                width: 2,
              ), // On-focus border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
