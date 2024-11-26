import 'package:flutter/material.dart';
import 'package:testnav/main.dart';

class miniPatientCard extends StatelessWidget {
  const miniPatientCard({super.key, this.onPressed});
  final void Function()? onPressed;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: currentBG2,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: currentTextColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.person, color: currentTextColor),
        title: Text(
          "Latest Diagnosis",
          style: TextStyle(fontWeight: FontWeight.bold, color: currentTextColor),
        ),
        subtitle: Text(
          "Patient Name: John Doe\nDate of Birth: 01/01/1980",
          style: TextStyle(color: currentTextColor),
        ),
        trailing: Icon(Icons.info, color: currentTextColor),
      ),
    );
  }

  Future<String> getLatestPatientData(String type) async {
    var value = await hs.getLatestPatientData();
    if (value != null) {
      switch (type) {
        case 'patientName':
          return value['patientName'] ?? 'No patientName';
        case 'patientGender':
          return value['patientGender'] ?? 'Others';
        case 'patientDOB':
          return value['patientDOB'] ?? '0/0/0';
      }
    }
    return 'Error';
  }

}
