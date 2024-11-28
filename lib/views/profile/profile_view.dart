import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/colors.dart';
import 'package:testnav/widgets/profileData.dart';
import 'package:testnav/widgets/selectbox.dart';
import 'package:testnav/widgets/selectdate.dart';
import 'package:testnav/widgets/textfield.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key});

  ProfileData profileData = ProfileData();

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  SignUpAndLogin signupLogin = SignUpAndLogin();
  bool _isSigningOut = false; // Track sign-out state

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _initializeUserData() async {
    _firstNameController.text = await hs.getUserFirstName();
    _lastNameController.text = await hs.getUserLastName();
  }

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: currentBG,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ListView(
                  children: [
                    Text("Profile",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DM Sans')),
                    const SizedBox(height: 20),
                    widget.profileData.buildProfileImage(40.0),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.profileData.buildUserDataText(
                          futureKey: "userFirstName",
                          isBold: true,
                          fontSize: 18,
                        ),
                        const SizedBox(width: 5),
                        widget.profileData.buildUserDataText(
                          futureKey: "userLastName",
                          isBold: true,
                          fontSize: 18,
                        ),
                      ],
                    ),
                    Center(
                      child: widget.profileData.buildUserDataText(
                        futureKey: "userEmail",
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            hint: "First Name",
                            label: "What's your first name?",
                            controller: _firstNameController,
                            outLine: false,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            hint: "Last Name",
                            label: "What's your last name?",
                            controller: _lastNameController,
                            outLine: false,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            hint: "Phone Number",
                            isIconed: true,
                            icon: const Icon(Icons.phone),
                            label: "Phone Number",
                            controller: _phoneNumberController,
                            outLine: false,
                          ),
                          const SizedBox(height: 20),
                          CustomSelectBox(
                            items: ['Male', 'Female'],
                            label: "Gender",
                            hint: "Choose one",
                            selectedValue: "Male",
                            onChanged: (value) {
                              print("Selected: $value");
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomDateSelection(
                            label: "Select Date",
                            hint: "What is your date of birth?",
                            selectedDate: DateTime.now(),
                            onDateSelected: (date) {
                              print(
                                  "Selected Date: ${DateFormat('yyyy-MM-dd').format(date)}");
                            },
                            isIconed: true,
                            icon: const Icon(Icons.calendar_today),
                            backgroundColor: Colors.grey[200]!,
                            focusedBorderColor: Colors.blue,
                          ),
                          const SizedBox(height: 45),
                          Center(
                            child: CustomButton(
                                label: 'Update Profile',
                                onPressed: () => updateProfile(context)),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: CustomButton(
                              label: "Sign Out",
                              BGColor: Colors.red,
                              size: 200,
                              isDisabled: _isSigningOut,
                              // Disable the button
                              onPressed: _isSigningOut
                                  ? null
                                  : () async {
                                      await _handleSignOut(context);
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _handleSignOut(BuildContext context) async {
    setState(() {
      _isSigningOut = true; // Disable the button
    });

    bool signOutSuccess = await signupLogin.signOut(context);

    if (signOutSuccess) {
      // Sign out logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed out successfully!'),
          backgroundColor: successSnackBarBG,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign out failed!'),
          backgroundColor: errorSnackBarBG,
        ),
      );
    }

    setState(() {
      _isSigningOut = false; // Re-enable the button
    });
  }

  void updateProfile(BuildContext context) {
    print('Update profile');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile Updated Successfully!'),
        backgroundColor: successSnackBarBG,
      ),
    );
  }
}
