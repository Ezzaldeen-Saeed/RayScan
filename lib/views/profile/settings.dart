import 'package:flutter/material.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/pallet.dart';

class Settings_subview extends StatefulWidget {
  Settings_subview({super.key});

  @override
  State<Settings_subview> createState() => _Settings_subviewState();
}

class _Settings_subviewState extends State<Settings_subview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: CustomText("Settings", 1)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 33),
            CustomProfileButton(label: "Notification Settings"),
            const SizedBox(height: 33),
            CustomProfileButton(label: "Password Manager"),
            const SizedBox(height: 33),
            CustomProfileButton(label: "Delete Account"),
          ],
        ),
      ),
    );
  }
}
