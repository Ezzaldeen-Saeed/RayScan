import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/customDialog.dart';
import 'package:testnav/widgets/customSnackbar.dart';
import 'package:testnav/widgets/miniPatientCard.dart';
import 'package:testnav/widgets/pallet.dart';

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
            .toSet() // Convert to a Set to ensure uniqueness
            .join(', ') // Convert back to a comma-separated string
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
                return CustomDialog(
                  onContinue: () {
                    Navigator.of(context).pop(); // Close the dialog
                    CustomSnackbar(
                            title:
                                'Patient ${patient['firstName']} ${patient['lastName']} deleted',
                            actionLabel: "Undo",
                            backgroundColor: undoSnackbarBG,
                            fontColor: undoSnackbarFont,
                            hasAction: true,
                            onPressAction: () {})
                        .showUndo(maincontext, patient['id']);
                  },
                  onHintTap: () {},
                  hasHint: true,
                  hasBackOption: true,
                  hintIcon: Icons.warning_amber_rounded,
                  backgroundColor: confirmAlertDialogBg,
                  fontColor: confirmAlertDialogFont,
                  title: 'Confirm Deletion!',
                  continueButtonChild: const Text("Confirm",
                      style: TextStyle(color: Colors.white)),
                );
              },
            );
          },
        );
      },
    );
  }
}
