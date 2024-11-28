import 'package:flutter/material.dart';
import 'package:testnav/widgets/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.textColor = Colors.white,
    this.BGColor = primaryColor,
    this.size = 260,
    this.isDisabled = false,
  });

  final bool isDisabled;
  final String label;
  final Color BGColor, textColor;
  final double size;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey : BGColor,
          // Change color when disabled
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: isDisabled ? null : onPressed, // Disable interaction
        child: Text(
          label,
          style: TextStyle(
            fontSize: size / 8.6,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class CustomButtonIcon extends StatelessWidget {
  const CustomButtonIcon(
      {super.key,
      required this.icon,
      required this.buttonColor,
      this.onPressed,
      required this.radius});

  final IconData icon;
  final Color buttonColor;
  final double radius;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: radius,
        height: radius,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor, // Set the button color
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(60), // Set max border radius
              ),
            ),
            onPressed: onPressed,
            child: Icon(
              icon,
              color: Colors.white,
              size: radius - radius * 0.3,
            )));
  }
}
