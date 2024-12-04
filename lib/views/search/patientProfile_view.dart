import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/colors.dart';
import 'package:testnav/widgets/selectbox.dart';
import 'package:testnav/widgets/selectdate.dart';
import 'package:testnav/widgets/textfield.dart';

class patientProfile_subview extends StatefulWidget {
  final Map<String, dynamic>? data; // Add a parameter to accept the data

  const patientProfile_subview({super.key, this.data});

  @override
  State<patientProfile_subview> createState() => _patientProfile_subviewState();
}

class _patientProfile_subviewState extends State<patientProfile_subview> {
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
    _firstNameController.text = await widget.data?['fName'];
    _lastNameController.text = await widget.data?['lName'];
    _phoneNumberController.text = await widget.data?['phoneNumber'];
  }

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  Widget build(BuildContext context) {
    final String? fname = widget.data?['fName'];
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
                    Text("Patient Profile",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DM Sans')),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        // First letter of the name
                        fname.toString()[0],
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
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
                            selectedValue: widget.data?['gender'] == "Male"
                                ? "Male"
                                : "Female",
                            onChanged: (value) {
                              print("Selected: $value");
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomDateSelection(
                            hint: "Select Date",
                            label: "What is your date of birth?",
                            selectedDate:
                                (widget.data?['birthDate'] is Timestamp)
                                    ? (widget.data?['birthDate'] as Timestamp?)
                                        ?.toDate()
                                    : null,
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
