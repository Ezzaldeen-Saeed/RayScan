import 'package:flutter/material.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/profileData.dart';

class MiniProfileCard extends StatelessWidget {
  MiniProfileCard({super.key, this.onPressed});

  final void Function()? onPressed;

  ProfileData profileData = ProfileData();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: currentBG2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          profileData.buildProfileImage(45.0),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileData.buildUserDataText(
                futureKey: "userFirstName",
                prefix: "Welcome, ",
                defaultText: "No user data available.",
                isBold: true,
                fontSize: 20,
              ),
              const SizedBox(height: 5),
              profileData.buildUserDataText(
                futureKey: "userEmail",
                defaultText: "No user data available.",
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(darkMode ? Icons.dark_mode : Icons.light_mode),
            color: currentTextColor,
          ),
        ],
      ),
    );
  }
}
