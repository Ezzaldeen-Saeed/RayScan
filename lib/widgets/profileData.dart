import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/pallet.dart';

class ProfileImage extends StatefulWidget {
  final double radius;
  final bool isEditable;

  const ProfileImage({
    Key? key,
    required this.radius,
    required this.isEditable,
  }) : super(key: key);

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // Load the profile image from the saved path
  Future<void> _loadProfileImage() async {
    final path = await hs.getProfileImagePath();
    setState(() {
      _imagePath = path;
    });
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    try {
      final XFile? selectedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage == null) return; // No image selected

      // Save the selected image path
      await hs.setProfileImagePath(selectedImage.path);

      // Refresh the profile image
      setState(() {
        _imagePath = selectedImage.path;
      });

      // Provide user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imagePath ?? 'assets/others/defaultProfileImage.png';

    return GestureDetector(
      onTap: () {
        if (widget.isEditable) _pickImage(); // Open image picker if editable
      },
      child: Stack(
        children: [
          CircleAvatar(
            radius: widget.radius - 3,
            backgroundImage: imageUrl.startsWith('assets/')
                ? AssetImage(imageUrl) as ImageProvider
                : FileImage(File(imageUrl)),
            backgroundColor: Colors.transparent,
          ),
          if (widget.isEditable)
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProfileData {
  Widget buildUserEmail() {
    Future<String> value;
    value = hs.getUserEmail();
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
            "${snapshot.data}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: currentTextColor,
            ),
          );
        } else {
          return Text(
            "Loading...",
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
  final TextOverflow isOverflow;

  const UserNameWidget(
      {super.key,
      this.textType = 1.1,
      this.color = Colors.black,
      this.isOverflow = TextOverflow.visible});

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
          return CustomText("Loading...", textType,
              color: color, isOverflow: isOverflow);
        } else if (snapshot.hasError) {
          return CustomText("Error: ${snapshot.error}", textType,
              color: color, isOverflow: isOverflow);
        } else if (snapshot.hasData) {
          return CustomText(snapshot.data!, textType,
              color: color, isOverflow: isOverflow);
        } else {
          return CustomText("No data available", textType,
              color: color, isOverflow: isOverflow);
        }
      },
    );
  }
}
