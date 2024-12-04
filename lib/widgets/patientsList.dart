import 'package:flutter/material.dart';
import 'package:testnav/widgets/miniPatientCard.dart';

class PatientList extends StatelessWidget {
  final List<Map<String, dynamic>> patients;

  const PatientList({super.key, required this.patients});

  @override
  Widget build(BuildContext context) {
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
        );
      },
    );
  }
}
