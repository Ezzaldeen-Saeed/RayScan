import 'package:flutter/material.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/profileData.dart';

class MiniProfileCard extends StatelessWidget {
  MiniProfileCard({super.key, this.onPressed});

  final void Function()? onPressed;

  final ProfileData profileData = ProfileData();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          profileData.buildProfileImage(35.0, false),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Hi, Welcome Back",
                3,
                isOverflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              UserNameWidget(
                textType: 1,
                isOverflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(darkMode ? Icons.dark_mode : Icons.light_mode),
            color: primaryColor,
          ),
        ],
      ),
    );
  }
}
