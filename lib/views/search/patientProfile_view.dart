import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/textfield.dart';
import 'package:testnav/widgets/toggleButton.dart';

class patientProfile_subview extends StatefulWidget {
  final Map<String, dynamic>? data;

  const patientProfile_subview({super.key, this.data});

  @override
  State<patientProfile_subview> createState() => _patientProfile_subviewState();
}

class _patientProfile_subviewState extends State<patientProfile_subview> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final SignUpAndLogin signupLogin = SignUpAndLogin();
  final List<bool> _isSelected = [true, false]; // Initialize _isSelected
  late List<bool> _isSelected2 = [true, false]; // Initialize _isSelected
  final AuthService _auth = AuthService();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _initializeUserData() async {
    _firstNameController.text = widget.data?['fName'] ?? '';
    _lastNameController.text = widget.data?['lName'] ?? '';
    _phoneNumberController.text = widget.data?['phoneNumber'] ?? '';
    _genderController.text = widget.data?['gender'] ?? '';
    if (widget.data?['gender'] == 'Female') _isSelected2 = [false, true];
    _dobController.text = widget.data?['birthDate'] ?? '';
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: CustomText("Patient Profile", 1),
          backgroundColor: currentBG,
          iconTheme: IconThemeData(color: currentTextColor),
        ),
        backgroundColor: currentBG,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        fname?.isNotEmpty == true
                            ? fname![0].toUpperCase()
                            : '?',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: CustomToggleButtons(
                        labels: ['Profile Data', 'Diagnosis Data'],
                        isSelected: _isSelected,
                        onToggle: (int index) {
                          setState(() {
                            for (int i = 0; i < _isSelected.length; i++) {
                              _isSelected[i] = i == index;
                            }
                          });
                        },
                        type: 2,
                        selectedColor: Colors.white,
                        borderColor: Colors.blue,
                        padding: 16.0,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _isSelected[0] ? patientDetails() : DiagnosisData(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  patientDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText("First Name", 2),
          ),
          CustomTextFieldV2(
            type: 1.0,
            isPassword: false,
            controller: _firstNameController,
            hint: "Joe",
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText("Last Name", 2),
          ),
          CustomTextFieldV2(
            type: 1.0,
            isPassword: false,
            controller: _lastNameController,
            hint: "Doe",
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText("Phone Number", 2),
          ),
          CustomTextFieldV2(
            type: 1.0,
            isPassword: false,
            controller: _phoneNumberController,
            hint: "1234567890",
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText("Gender", 2),
          ),
          Center(
            child: CustomToggleButtons(
              labels: ['Male', 'Female'],
              isSelected: _isSelected2,
              onToggle: (int index) {
                setState(() {
                  for (int i = 0; i < _isSelected2.length; i++) {
                    _isSelected2[i] = i == index;
                  }
                });
              },
              type: 1,
              selectedColor: Colors.white,
              borderColor: Colors.blue,
              padding: 16.0,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText("Date of Birth", 2),
          ),
          CustomTextFieldV2(
              type: 1.0,
              isPassword: false,
              controller: _dobController,
              hint: "DD/MM/YYYY"),
          const SizedBox(height: 45),
          Center(
            child: CustomButton(
                label: 'Update Profile',
                onPressed: () => updateProfile(context)),
          ),
          const SizedBox(height: 10),
          Center(
            child: CustomButton(
              label: "Delete Patient",
              BGColor: Colors.red,
              size: 200,
              isDisabled: false,
              // Disable the button
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Delete Patient'),
                    content: const Text(
                        'Are you sure you want to delete this patient?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                          // Show feedback using the correct context
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Patient ${widget.data?['fName']} ${widget.data?['lName']} deleted.",
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          // Perform deletion
                          _auth.deletePatient(widget.data?['id']);
                          // Navigate back to the previous screen
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DiagnosisData() {
    return Center(
      child: Text("Diagnosis Data"),
    );
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