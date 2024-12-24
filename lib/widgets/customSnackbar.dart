import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/pallet.dart';

class CustomSnackbar {
  final String title;
  final VoidCallback? onPressAction;
  final Color backgroundColor;
  final Color fontColor;
  final bool hasAction;
  final String actionLabel;
  final IconData? icon;

  const CustomSnackbar({
    required this.title,
    this.onPressAction,
    required this.backgroundColor,
    required this.fontColor,
    this.hasAction = false,
    this.actionLabel = '',
    this.icon,
  });

  void show(BuildContext context) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      action: hasAction
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onPressAction ?? () {},
              textColor: fontColor,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showUndo(BuildContext context, String patientId) {
    final AuthService authService = AuthService();
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: primaryColor,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      action: hasAction
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onPressAction ?? () {},
              textColor: fontColor,
            )
          : null,
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((SnackBarClosedReason reason) {
      if (reason != SnackBarClosedReason.action) {
        authService.deletePatient(patientId);
      }
    });
  }
}
