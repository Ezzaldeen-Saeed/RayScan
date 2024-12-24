import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testnav/widgets/customDialog.dart';

class DiagnosesPage extends StatelessWidget {
  final String pid, gender, fName, lName, DOB;

  const DiagnosesPage(
      {super.key,
      required this.pid,
      required this.gender,
      required this.fName,
      required this.lName,
      required this.DOB}); // Initialize pid in the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Constrained ListView
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Replace this with your actual list items
                for (int i = 1; i <= 20; i++)
                  ListTile(
                    title: Text('Diagnosis $i'),
                    subtitle: Text('Details for diagnosis $i'),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DiagnosisCustomDialog(
                      PID: pid,
                      fName: fName,
                      lName: lName,
                      gender: gender,
                      DOB: DOB, mainContext: context
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
