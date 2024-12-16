import 'package:flutter/material.dart';
import 'package:testnav/widgets/pallet.dart';

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

class CustomTextFieldV2 extends StatefulWidget {
  const CustomTextFieldV2({
    super.key,
    required this.type,
    this.hint = '*************',
    this.label = '',
    this.controller,
    this.isPassword = false,
    this.backgroundColor = textFieldBGColor,
    this.focusedBorderColor = primaryColor,
    this.keyboardType,
  });

  final double type;
  final String hint;
  final String label;
  final TextEditingController? controller;
  final bool isPassword;
  final Color backgroundColor; // Background color of the text field
  final Color focusedBorderColor; // Border color when the text field is focused
  final TextInputType? keyboardType;

  @override
  State<CustomTextFieldV2> createState() => _CustomTextFieldV2State();
}

class _CustomTextFieldV2State extends State<CustomTextFieldV2> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword; // Initialize based on `isPassword`
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscuringCharacter: '*',
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      style: TextStyle(
        color: primaryColor,
        fontSize: fontSizeTitle,
        fontWeight: fontWeightSimiBold,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: fontSizeTitle,
          fontWeight: fontWeightSimiBold,
        ),
        filled: true,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        fillColor: widget.backgroundColor,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );
  }
}
