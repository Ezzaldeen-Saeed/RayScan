import 'package:flutter/material.dart';
import 'package:testnav/widgets/pallet.dart';

class CustomDialog extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onContinue;
  final VoidCallback onHintTap;
  final Color backgroundColor;
  final Color fontColor;
  final bool hasHint;
  final String title;
  final Widget continueButtonChild;
  final IconData hintIcon;
  final bool hasBackOption;

  const CustomDialog({
    Key? key,
    this.animation = const AlwaysStoppedAnimation(1),
    required this.onContinue,
    this.hintIcon = Icons.error_outline,
    this.hasHint = false,
    this.hasBackOption = false,
    required this.onHintTap,
    required this.backgroundColor,
    required this.fontColor,
    required this.title,
    required this.continueButtonChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textAlign: TextAlign.center,
              title,
              style: TextStyle(
                color: fontColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            hasHint
                ? GestureDetector(
                    onTap: onHintTap,
                    child: ScaleTransition(
                      scale: animation,
                      child: Icon(
                        hintIcon,
                        size: 30,
                        color: fontColor,
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fontColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: continueButtonChild,
                ),
                const Spacer(),
                hasBackOption
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: confirmAlertDialogCancelBG,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: confirmAlertDialogCancelFont),
                        ),
                      )
                    : const SizedBox(),
                hasBackOption ? const Spacer() : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
