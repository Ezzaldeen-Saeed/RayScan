import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/miniPatientCard.dart';

class PatientList extends StatelessWidget {
  final List<Map<String, dynamic>> patients;
  final AuthService _auth = AuthService();

  PatientList({super.key, required this.patients});

  @override
  Widget build(BuildContext maincontext) {
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final record = patients[index];

        // Safely extract patient and diagnosis data
        final patient = record['patient'] as Map<String, dynamic>? ?? {};
        final diagnosis = record['diagnosis'] as List<dynamic>? ?? [];

        // Build the diagnosis summary
        final diagnosisSummary = diagnosis.isNotEmpty
            ? diagnosis
                .map((diag) => (diag as Map<String, dynamic>)['label'] ?? '')
                .where((diag) => diag.isNotEmpty) // Filter out empty diagnoses
                .join(', ')
            : 'No diagnosis available';

        // Build the patient profile card
        return PatientProfileCard(
          id: patient['id'] ?? 'Unknown',
          fName: patient['firstName'] ?? 'Unknown',
          lName: patient['lastName'] ?? 'Unknown',
          gender: patient['gender'] ?? 'Unknown',
          age: patient['age'] ?? 0,
          birthDate: patient['birthDate'],
          phoneNumber: patient['phoneNumber'] ?? 'N/A',
          disease: diagnosisSummary,
          onDismissed: () {
            // Show confirmation dialog before deletion
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Deletion'),
                  content: Text(
                      'Are you sure you want to delete patient ${patient['firstName']} ${patient['lastName']}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog

                        // Show a snackbar to indicate deletion with undo option
                        final snackBar = SnackBar(
                          content: Text(
                              'Patient ${patient['firstName']} ${patient['lastName']} deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );

                        // Show the SnackBar and wait for it to close
                        ScaffoldMessenger.of(maincontext)
                            .showSnackBar(snackBar)
                            .closed
                            .then((SnackBarClosedReason reason) {
                          if (reason != SnackBarClosedReason.action) {
                            // Call the deletion function if not undone
                            _auth.deletePatient(patient['id']);
                          }
                        });
                      },
                      child:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
