import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';

class CustomSnackbar {
  final String title;
  final VoidCallback? onPressAction;
  final Color backgroundColor;
  final Color fontColor;
  final bool hasAction;
  final String actionLabel;

  const CustomSnackbar({
    required this.title,
    this.onPressAction,
    required this.backgroundColor,
    required this.fontColor,
    this.hasAction = false,
    this.actionLabel = '',
  });

  void show(BuildContext context) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: backgroundColor,
      content: Text(
        title,
        style: TextStyle(
          color: fontColor,
          fontSize: 16,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );

    // Show the SnackBar and wait for it to close
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showUndo(BuildContext context, String patientId) {
    final AuthService authService = AuthService();
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: backgroundColor,
      content: Text(
        title,
        style: TextStyle(
          color: fontColor,
          fontSize: 16,
        ),
      ),
      action: hasAction
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onPressAction ?? () {},
              textColor: fontColor,
            )
          : null,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    );

    // Show the SnackBar and wait for it to close
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((SnackBarClosedReason reason) {
      if (reason != SnackBarClosedReason.action) {
        // Call the deletion function if not undone
        authService.deletePatient(patientId);
      }
    });
  }
}
