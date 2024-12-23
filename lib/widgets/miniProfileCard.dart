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
  Future<String> getUserFullName() async {
    String? firstName = await hs.getUserFirstName();
    String? lastName = await hs.getUserLastName();

    // Provide default values if names are null
    firstName = firstName ?? "Guest";
    lastName = lastName ?? "";

    return '$firstName $lastName'.trim();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getUserFullName(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(onTap: onPressed, child: profileData),
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
                    if (snapshot.connectionState == ConnectionState.waiting)
                      CustomText("Loading...", 1.1,
                          color: Colors.black, isOverflow: TextOverflow.visible)
                    else if (snapshot.hasError)
                      CustomText("Error: ${snapshot.error}", 1.1,
                          color: Colors.black, isOverflow: TextOverflow.visible)
                    else if (snapshot.hasData && snapshot.data != null)
                      CustomText(snapshot.data!, 1.1,
                          color: Colors.black, isOverflow: TextOverflow.visible)
                    else
                      CustomText("No data available", 1.1,
                          color: Colors.black, isOverflow: TextOverflow.visible)
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
        });
  }
}
