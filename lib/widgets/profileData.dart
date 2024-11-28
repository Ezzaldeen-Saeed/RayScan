import 'package:flutter/material.dart';
import 'package:testnav/main.dart';

class ProfileData {
  // Builds the profile image FutureBuilder
  Widget buildProfileImage(double radius) {
    return FutureBuilder<String>(
      future: hs.getProfileImagePath(),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ??
            'https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg';
        return CircleAvatar(
          radius: radius,
          backgroundColor: Colors.blueAccent,
          child: CircleAvatar(
            radius: radius - 3,
            backgroundImage: snapshot.hasError || !snapshot.hasData
                ? NetworkImage(imageUrl)
                : NetworkImage(snapshot.data!),
          ),
        );
      },
    );
  }

  // Builds a reusable FutureBuilder for user data text
  Widget buildUserDataText({
    required String futureKey,
    String prefix = "",
    String defaultText = "",
    bool isBold = false,
    double fontSize = 16,
  }) {
    // Declare a Future<String> variable
    Future<String> value;

    // Assign the correct Future<String> based on futureKey
    switch (futureKey) {
      case 'userFirstName':
        value = hs.getUserFirstName();
        break;
      case 'userLastName':
        value = hs.getUserLastName();
        break;
      case 'userEmail':
        value = hs.getUserEmail();
        break;
      default:
        // Use Future.value to return a resolved future
        value = Future.value("Error fetching data");
        break;
    }

    return FutureBuilder<String>(
      future: value,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: TextStyle(color: currentTextColor),
          );
        } else if (snapshot.hasData) {
          return Text(
            "$prefix${snapshot.data}",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: currentTextColor,
            ),
          );
        } else {
          return Text(
            defaultText,
            style: TextStyle(color: currentTextColor),
          );
        }
      },
    );
  }
}
