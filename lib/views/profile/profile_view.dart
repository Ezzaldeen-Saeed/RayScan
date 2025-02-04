import 'package:flutter/material.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/profileData.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key});

  final ProfileImage profileData = ProfileImage(radius: 63.0, isEditable: true);
  final ProfileData miniProfileCard = ProfileData();

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: currentBG,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                  child: CustomText(
                "My Profile",
                1,
              )),
              Center(child: widget.profileData),
              const SizedBox(height: 10),
              Center(child: UserNameWidget()),
              Center(
                child: widget.miniProfileCard.buildUserEmail(),
              ),
              const SizedBox(height: 96),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomProfileButton(label: "Settings"),
                    const SizedBox(height: 33),
                    CustomProfileButton(label: "Help"),
                    const SizedBox(height: 33),
                    CustomProfileButton(label: "Logout"),
                    const SizedBox(height: 33),
                    CustomProfileButton(label: "About"),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
