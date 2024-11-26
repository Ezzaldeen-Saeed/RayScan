import 'package:flutter/material.dart';

import 'package:testnav/main.dart';

import '../auth/auth_service.dart';

class miniProfileCard extends StatelessWidget {
  const miniProfileCard({super.key, this.onPressed});
  final void Function()? onPressed;


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
          FutureBuilder<String>(
            future: getUserData("profileImagePath"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blueAccent,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.grey,
                  ),
                );
              } else if (snapshot.hasError) {
                return CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blueAccent,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundImage: const NetworkImage(
                      'https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg',
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blueAccent,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundImage: NetworkImage(snapshot.data!),
                  ),
                );
              } else {
                return const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blueAccent,
                );
              }
            },
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: getUserData("userName"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}', style: TextStyle(color: currentTextColor));
                  } else if (snapshot.hasData) {
                    return Text(
                      "Welcome, ${snapshot.data}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: currentTextColor),
                    );
                  } else {
                    return Text("No user data available.", style: TextStyle(color: currentTextColor));
                  }
                },
              ),
              const SizedBox(height: 5),
              FutureBuilder<String>(
                future: getUserData("userEmail"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}', style: TextStyle(color: currentTextColor));
                  } else if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data}",
                      style: TextStyle(color: currentTextColor),
                    );
                  } else {
                    return Text("No user data available.", style: TextStyle(color: currentTextColor));
                  }
                },
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: onPressed,
            icon: Icon(darkMode ? Icons.dark_mode : Icons.light_mode),
            color: currentTextColor,
          ),
        ],
      ),
    );
  }

  Future<String> getUserData(String type) async {
    var value = await hs.getUserData();
    if (value != null) {
      switch (type) {
        case 'userName':
          return value['userName'] ?? 'No userName';
        case 'userEmail':
          return value['userEmail'] ?? 'No userEmail';
        case 'profileImagePath':
          return value['profileImagePath'] ??
              'https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg';
      }
    }
    return 'Error';
  }
}
