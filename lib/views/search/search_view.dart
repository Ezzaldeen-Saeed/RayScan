import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/utils/utility.dart';
import 'package:testnav/widgets/advancedSearchDialog.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/patientsList.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();

  String? selectedGender;
  String? selectedDisease;
  RangeValues ageRange = RangeValues(0, 100);

  List<Map<String, dynamic>> records = [];
  List<Map<String, dynamic>> filteredPatients = [];
  bool isLoading = false;

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fetched ${records.length} patients'),
          ),
        );
      });
    }
  }

  void filterPatients() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredPatients = records.where((record) {
        final patient = record['patient'];

        final String patientFirstName =
            (patient['firstName'] ?? '').toLowerCase();
        final String patientLastName =
            (patient['lastName'] ?? '').toLowerCase();
        final String patientFullName = '$patientFirstName $patientLastName';

        final String patientId = (patient['id'] ?? '').toString().toLowerCase();

        // Check if the query matches either Name or ID
        bool matchesNameOrId = query.isEmpty ||
            patientFullName.contains(query) ||
            patientId.contains(query);

        final String patientGender = (patient['gender'] ?? '').toString();
        final int patientAge = patient['age'] ?? 0;

        bool matchesGender =
            selectedGender == null || patientGender == selectedGender;
        bool matchesDisease = selectedDisease == null ||
            _matchesDisease(record['diagnosis'], selectedDisease);
        bool matchesAge =
            patientAge >= ageRange.start && patientAge <= ageRange.end;

        return matchesNameOrId && matchesGender && matchesDisease && matchesAge;
      }).toList();
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

  void addRandomPatient() {
    final randomPatientGenerator = RandomPatientGenerator();
    final randomPatient = randomPatientGenerator.generateRandomPatient();

    auth.createNewPatient(
      randomPatient['firstName'],
      randomPatient['lastName'],
      randomPatient['dateOfBirth'],
      randomPatient['gender'],
      randomPatient['phone'],
      randomPatient['age'],
    );
    fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentBG,
      appBar: AppBar(
        backgroundColor: currentBG,
        surfaceTintColor: currentBG,
        centerTitle: true,
        title: CustomText('Search Patients', 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: addRandomPatient,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: unselectedButton,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_alt_rounded),
                    onPressed: showAdvancedSearchDialog,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search by Name or ID',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        suffixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => filterPatients(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => fetchPatients(),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator()) // Show loader
                    : PatientList(patients: filteredPatients),
              ),
            )
          ],
        ),
      ),
    );
  }
}
