import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/button.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/selectbox.dart';
import 'package:testnav/widgets/selectdate.dart';
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
            selectedValue: _genderController.text,
            onChanged: (value) {
              setState(() {
                _genderController.text = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          CustomDateSelection(
            label: "What is your date of birth?",
            selectedDate: _dobController.text.isNotEmpty
                ? DateFormat('dd/MM/yyyy').parse(
                    _dobController.text) // Updated to match the input format
                : null,
            onDateSelected: (date) {
              setState(() {
                _dobController.text = DateFormat('dd/MM/yyyy')
                    .format(date); // Keep consistent formatting
              });
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
