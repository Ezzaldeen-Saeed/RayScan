import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/advancedSearchDialog.dart';
import 'package:testnav/widgets/patientsList.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  String? selectedGender;
  String? selectedDisease;
  RangeValues ageRange = RangeValues(0, 100);

  List<Map<String, dynamic>> records = [];
  List<Map<String, dynamic>> filteredPatients = [];

  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    try {
      final patients = await auth.getCurrentUserPatientsFullDetails();
      setState(() {
        records = patients;
        filteredPatients = records;
      });
    } catch (e) {
      print("Error fetching patients: $e");
    }
  }

  void filterPatients() {
    setState(() {
      log('Filtering patients...\nName: ${nameController.text}\nID: ${idController.text}\nGender: $selectedGender\nDisease: $selectedDisease\nAge: ${ageRange.start} - ${ageRange.end}');
      log('Records: $records');

      filteredPatients = records.where((record) {
        // Extract the 'patient' object from the 'record' map
        final patient = record['patient'];

        // Ensure that the patient's fields exist and are not null
        final String patientName = (patient['firstName'] ?? '').toLowerCase();
        final String searchName = nameController.text.toLowerCase();
        final String patientId = (patient['id'] ?? '').toString();
        final String patientGender = (patient['gender'] ?? '').toString();
        final int patientAge = patient['age'] ?? 0;

        // Perform the filtering checks
        bool matchesName =
            nameController.text.isEmpty || patientName.contains(searchName);
        bool matchesId =
            idController.text.isEmpty || patientId == idController.text;
        bool matchesGender =
            selectedGender == null || patientGender == selectedGender;
        bool matchesDisease = selectedDisease == null ||
            _matchesDisease(record['diagnosis'], selectedDisease);
        bool matchesAge =
            patientAge >= ageRange.start && patientAge <= ageRange.end;

        return matchesName &&
            matchesId &&
            matchesGender &&
            matchesDisease &&
            matchesAge;
      }).toList();
    });
  }

// Helper function to check if any of the patient's diagnoses match the selected disease
  bool _matchesDisease(List diagnosisList, String? selectedDisease) {
    if (selectedDisease == null || diagnosisList.isEmpty) {
      return true; // No disease filter applied or no diagnoses available
    }

    // Check if any diagnosis matches the selected disease
    return diagnosisList.any((diagnosis) {
      final diagnosisLabel = (diagnosis['label'] ?? '').toLowerCase();
      return diagnosisLabel.contains(selectedDisease.toLowerCase());
    });
  }

  void showAdvancedSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AdvancedSearchDialog(
          selectedGender: selectedGender,
          selectedDisease: selectedDisease,
          ageRange: ageRange,
          onApply: (gender, disease, range) {
            setState(() {
              selectedGender = gender;
              selectedDisease = disease;
              ageRange = range;
            });
            filterPatients();
          },
          onReset: () {
            setState(() {
              selectedGender = null;
              selectedDisease = null;
              ageRange = RangeValues(0, 100);
            });
            filterPatients();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPatients,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: showAdvancedSearchDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Search by Name'),
              onChanged: (value) => filterPatients(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: 'Search by ID'),
              keyboardType: TextInputType.number,
              onChanged: (value) => filterPatients(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredPatients.isEmpty
                  ? const Center(child: Text('No patients found.'))
                  : PatientList(patients: filteredPatients),
            ),
            ElevatedButton(
                onPressed: () {
                  auth.addPatient(
                    'John',
                    'Doe',
                    Timestamp.fromDate(DateTime(1990, 5, 20)),
                    'Male',
                    '1234567890',
                    21,
                    [
                      {
                        'Diagnosis': 'Fibrosis 92%',
                        'Diagnosis_Date': Timestamp.fromDate(DateTime.now()),
                        'Image_Path': '/path/to/image1',
                        'label': 'Fibrosis',
                      },
                      {
                        'Diagnosis': 'Hernia 52%',
                        'Diagnosis_Date': Timestamp.fromDate(DateTime.now()),
                        'Image_Path': '/path/to/image2',
                        'label': 'Hernia',
                      }
                    ],
                  );
                },
                child: Text('Add Patient'))
          ],
        ),
      ),
    );
  }
}
