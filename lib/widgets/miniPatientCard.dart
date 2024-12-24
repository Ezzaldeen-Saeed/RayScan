import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/pallet.dart';

class PatientProfileCard extends StatelessWidget {
  final String id;
  final String gender;
  final int age;
  final Timestamp birthDate;
  final String fName;
  final String lName;
  final String phoneNumber;
  final String disease; // Accept dynamic disease summaries.
  final VoidCallback onDismissed; // Callback to remove the item from the list
  bool isDismissable = true;
  final AuthService auth = AuthService();

  PatientProfileCard({
    super.key,
    required this.id,
    required this.gender,
    required this.age,
    required this.disease,
    required this.fName,
    required this.phoneNumber,
    required this.birthDate,
    required this.lName,
    required this.onDismissed,
    this.isDismissable = true, // Initialize the callback
  });

  @override
  Widget build(BuildContext context) {
    // Convert Firestore Timestamp to readable date format
    final String formattedBirthDate =
        "${birthDate.toDate().day}/${birthDate.toDate().month}/${birthDate.toDate().year}";

    return isDismissable
        ? Dismissible(
            key: Key(id),
            // Unique key for this card
            direction: DismissDirection.endToStart,
            // Swipe from right to left
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 30,
              ),
            ),
            onDismissed: (direction) {
              onDismissed(); // Call the callback
            },
            child: _patientData(context, formattedBirthDate),
          )
        : _patientData(context, formattedBirthDate);
  }

  _patientData(BuildContext context, String formattedBirthDate) {
    return GestureDetector(
      onTap: () {
        context.go(
          isDismissable
              ? '/search/patientProfile_subview'
              : '/home/latestPatientProfile_subview',
          extra: {
            'id': id,
            'gender': gender,
            'age': age,
            'disease': disease,
            'fName': fName,
            'phoneNumber': phoneNumber,
            'birthDate': formattedBirthDate,
            'lName': lName,
          },
        );
      },
      child: Card(
        color: unselectedButton,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Profile Picture Placeholder
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    fName[0], // First letter of the name
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Disease Tag
                    Container(
                      decoration: BoxDecoration(
                        color: disease.contains('Fibrosis')
                            ? cardDisease1
                            : disease.contains('Hernia')
                                ? cardDisease2
                                : disease.contains('Effusion')
                                    ? cardDisease3
                                    : disease.contains('Cardiomegaly')
                                        ? cardDisease4
                                        : cardDisease5,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          disease, // Display the dynamic disease summary
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Name and Gender
                    Row(
                      children: [
                        Text(
                          '$fName $lName',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 7),
                        gender == 'Male'
                            ? const Icon(Icons.male_rounded,
                                color: Colors.blue, size: 20)
                            : const Icon(Icons.female_rounded,
                                color: Colors.pink, size: 20),
                      ],
                    ),
                    // Birth Date
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(229, 236, 236, 1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Age: $age'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
