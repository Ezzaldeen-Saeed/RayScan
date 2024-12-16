import 'package:flutter/material.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/pallet.dart';

class ProfileData {
  // Builds the profile image FutureBuilder
  Widget buildProfileImage(double radius, bool isEditable) {
    return FutureBuilder<String>(
      future: hs.getProfileImagePath(),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ??
            'https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg';
        return Stack(
          children: [
            CircleAvatar(
              radius: radius - 3,
              backgroundImage: snapshot.hasError || !snapshot.hasData
                  ? NetworkImage(imageUrl)
                  : NetworkImage(snapshot.data!),
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: radius * 2,
                  height: radius * 2,
                ),
              ),
            ),
            if (isEditable)
              Positioned(
                bottom: 10,
                right: 10, // Changed from left to right
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue, // Replace with desired color
                  ),
                  child: Center(
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
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

class UserNameWidget extends StatelessWidget {
  final double textType;
  final Color color;

  const UserNameWidget(
      {super.key, this.textType = 1.1, this.color = Colors.black});

  // Returns the full name of the user
  Future<String> getUserFullName() async {
    String firstName = await hs.getUserFirstName();
    String lastName = await hs.getUserLastName();
    return '$firstName $lastName';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserFullName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomText("Loading...", textType, color: color);
        } else if (snapshot.hasError) {
          return CustomText("Error: ${snapshot.error}", textType, color: color);
        } else if (snapshot.hasData) {
          return CustomText(snapshot.data!, textType, color: color);
        } else {
          return CustomText("No data available", textType, color: color);
        }
      },
    );
  }
}
