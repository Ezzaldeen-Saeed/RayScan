import 'package:flutter/material.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/profileData.dart';

class MiniProfileCard extends StatelessWidget {
  MiniProfileCard({super.key, this.onPressed});

  final void Function()? onPressed;

  final ProfileImage profileData =
      ProfileImage(radius: 63.0, isEditable: false);


  // Returns the full name of the user
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(onTap: onPressed, child: profileData),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "Hi, Welcome Back",
                    2,
                    isOverflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
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
        ],
      ),
    );
  }
}
