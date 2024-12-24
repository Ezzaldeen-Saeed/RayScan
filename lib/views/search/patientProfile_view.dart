import 'package:flutter/material.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/textfield.dart';
import 'package:testnav/widgets/toggleButton.dart';
import 'diagnosesPage.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        fname?.isNotEmpty == true ? fname![0].toUpperCase() : '?',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomToggleButtons(
                      labels: ['Profile', 'Diagnoses'],
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
                    const SizedBox(height: 15),
                    Expanded(
                      child: _isSelected[0] ? patientDetails() : DiagnosesPage(pid: widget.data?['id'], fName: widget.data?['fName'], lName: widget.data?['lName'], gender: widget.data?['gender'], DOB: widget.data?['birthDate']  ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
        ],
      ),
    );
  }

  void updateProfile(BuildContext context) {
    //TODO --> EZZ
  }
}