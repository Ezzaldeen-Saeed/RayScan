import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/pallet.dart';

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

class CustomProfileButton extends StatelessWidget {
  CustomProfileButton({
    super.key,
    required this.label,
    this.onPressed,
    this.textColor = Colors.black,
    this.BGColor = primaryColor,
  });

  final String label;
  final Color BGColor, textColor;
  final void Function()? onPressed;

  final SignUpAndLogin signupLogin = SignUpAndLogin();

  Future<bool> _handleSignOut(BuildContext context) async {
    print("Context $context");

    bool signOutSuccess = await signupLogin.signOut(context);

    if (signOutSuccess) {
      print("User Logged Out");
      return true;
    } else {
      print("Error Logging Out");
      return false;
    }
  }

  @override
  Widget build(BuildContext maincontext) {
    return Material(
      color: Colors.transparent, // To maintain the background color
      child: InkWell(
        onTap: () async {
          if (label == "Logout") {
            showDialog(
              context: maincontext,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Logout"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Dismiss the dialog
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Dismiss the dialog
                        bool signOutSuccess = await _handleSignOut(maincontext);
                        if (signOutSuccess) {
                          ScaffoldMessenger.of(maincontext).showSnackBar(
                            SnackBar(
                              content: Text("User Logged Out Successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(maincontext).showSnackBar(
                            SnackBar(content: Text("Error Logging Out")),
                          );
                        }
                      },
                      child: Text("Logout"),
                    ),
                  ],
                );
              },
            );
          } else {
            maincontext.go(
              label == "Settings"
                  ? '/profile/Settings_subview'
                  : label == "Help"
                      ? '/profile/Help_subview'
                      : label == "About"
                          ? '/profile/About_subview'
                          : '/error',
            );
          }
        },
        child: Row(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFBDD7E5),
                    ),
                  ),
                  label == "Settings"
                      ? Icon(
                          Icons.settings_outlined,
                          color: primaryColor,
                          size: 35,
                        )
                      : label == "Help"
                          ? Icon(
                              Icons.question_mark,
                              color: primaryColor,
                              size: 35,
                            )
                          : label == "Logout"
                              ? Icon(
                                  Icons.logout_outlined,
                                  color: primaryColor,
                                  size: 35,
                                )
                              : Icon(
                                  Icons.error_outline,
                                  color: primaryColor,
                                  size: 35,
                                )
                ],
              ),
            ),
            const SizedBox(width: 10),
            CustomText(label, 1),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
