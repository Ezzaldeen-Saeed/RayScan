import 'dart:io';
import 'package:flutter/material.dart';
import 'package:testnav/widgets/customDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiagnosesPage extends StatelessWidget {
  final String pid, gender, fName, lName, DOB;

  const DiagnosesPage({
    super.key,
    required this.pid,
    required this.gender,
    required this.fName,
    required this.lName,
    required this.DOB,
  });

  Future<List<Map<String, dynamic>>> fetchDiagnoses(String pid) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await _firestore
          .collection('Diagnosis')
          .where('PID', isEqualTo: pid)
          .orderBy('Diagnosis_Date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          ...doc.data(),
          'docId': doc.id,
        } as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error fetching diagnoses: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fetch and display diagnoses
          Positioned.fill(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchDiagnoses(pid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading diagnoses',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No diagnoses available'),
                  );
                }

                final diagnoses = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: diagnoses.length,
                  itemBuilder: (context, index) {
                    final diagnosis = diagnoses[index];
                    return ListTile(
                      title: Text(diagnosis['label'] ?? 'Unknown Diagnosis'),
                      subtitle: Text(
                        'Date: ${diagnosis['Diagnosis_Date'].toDate()}',
                      ),
                      trailing: Text(diagnosis['ModelType'] ?? 'Unknown Model'),
                    );
                  },
                );
              },
            ),
          ),
          // Floating action button to add new diagnosis
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
                      DOB: DOB,
                      mainContext: context,
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
