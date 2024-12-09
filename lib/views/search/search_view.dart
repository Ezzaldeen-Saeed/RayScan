import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/utils/utility.dart';
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
  bool isLoading = false; // New state variable for loading

  final AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      final patients = await auth.getCurrentUserPatientsFullDetails();
      setState(() {
        records = patients;
        filteredPatients = records;
      });
    } catch (e) {
      print("Error fetching patients: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  void filterPatients() {
    setState(() {
      // Filter logic remains unchanged
      final filtered = records.where((record) {
        final patient = record['patient'];

        final String patientFirstName =
            (patient['firstName'] ?? '').toLowerCase();
        final String patientLastName =
            (patient['lastName'] ?? '').toLowerCase();
        final String patientFullName = '$patientFirstName $patientLastName';
        final String searchName = nameController.text.toLowerCase();

        final String patientId = (patient['id'] ?? '').toString().toLowerCase();
        final String searchId = idController.text.toLowerCase();

        final String patientGender = (patient['gender'] ?? '').toString();
        final int patientAge = patient['age'] ?? 0;

        bool matchesName =
            searchName.isEmpty || patientFullName.contains(searchName);
        bool matchesId = searchId.isEmpty || patientId.contains(searchId);
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

      filteredPatients = filtered;
    });
  }

  bool _matchesDisease(List diagnosisList, String? selectedDisease) {
    if (selectedDisease == null || diagnosisList.isEmpty) {
      return true;
    }

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
            onPressed: fetchPatients,
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
              onChanged: (value) => filterPatients(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator()) // Show loader
                  : filteredPatients.isEmpty
                      ? const Center(child: Text('No patients found.'))
                      : PatientList(patients: filteredPatients),
            ),
            // this button is for adding random patients
            ElevatedButton(
              onPressed: () {
                final randomPatientGenerator = RandomPatientGenerator();
                final randomPatient =
                    randomPatientGenerator.generateRandomPatient();

                auth.createNewPatient(
                  randomPatient['firstName'],
                  randomPatient['lastName'],
                  randomPatient['dateOfBirth'],
                  randomPatient['gender'],
                  randomPatient['phone'],
                  randomPatient['age'],
                );
                fetchPatients();
              },
              child: const Text('Add Random Patient'),
            ),
          ],
        ),
      ),
    );
  }
}

