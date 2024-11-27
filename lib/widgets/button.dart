import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.label, this.onPressed});
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 180,
        height: 42,
        child: ElevatedButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(fontSize: 18),
            )));
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