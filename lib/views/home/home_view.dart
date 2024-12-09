import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/miniPatientCard.dart';
import 'package:testnav/widgets/miniProfileCard.dart';

class HomeView extends StatelessWidget {
  final AuthService auth = AuthService();

  final SignUpAndLogin signupLogin = SignUpAndLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentBG,
      body: Align(
        alignment: Alignment.center,
        child: ListView(
          children: [
            MiniProfileCard(onPressed: () {
              context.goNamed("Profile");
            }),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Patients:',
                    style: TextStyle(
                      color: currentTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PatientProfileCard(
                      id: "1",
                      fName: "John",
                      lName: "Doe",
                      gender: "Male",
                      age: 21,
                      birthDate: Timestamp.now(),
                      phoneNumber: "1234567890",
                      disease: 'Covid-19',
                      onDismissed: () {},
                      isDismissable: false),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
