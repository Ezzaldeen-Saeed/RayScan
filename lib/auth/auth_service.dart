import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

// EZZ
// https://concrete-grub-immensely.ngrok-free.app
// 2pDPe8ogpPOBHqz4nBgLkAcDbZ4_82p96Bo7vdpmcvDtKAWFN

// Shefo
// https://beloved-simply-piglet.ngrok-free.app
// 2pMS326VkCAcdJvvQsNGyAJbJSq_7oKjcn4FoEvS5ersmd5Ch

// to run NGROK: ngrok http --url=concrete-grub-immensely.ngrok-free.app 5000

final String flaskServerUrl = "https://beloved-simply-piglet.ngrok-free.app";
final String ngrokAuthKey = "2pMS326VkCAcdJvvQsNGyAJbJSq_7oKjcn4FoEvS5ersmd5Ch";

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final Logger log = Logger();

  Future<User?> createUserWithEmailAndPassword(
      String fName, String lName, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Get the user ID (UID)
      String userId = cred.user!.uid;

      // Save additional user data in Realtime Database
      await _firestore
          .collection('Users')
          .doc(userId)
          .set({'fName': fName, 'lName': lName});

      log.i("User registered and data saved successfully.");
      return cred.user;
    } catch (e) {
      log.e("Error in createUserWithEmailAndPassword: $e, Type: ${e.runtimeType}");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log.e("Error in loginUserWithEmailAndPassword: $e, Type: ${e.runtimeType}");
    }
    return null;
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('Users').doc(user.uid).get();
        log.i("UserID: ${user.uid}, Requested Current User's Data.");
        return {
          'userFirstName': doc['fName'],
          'userLastName': doc['lName'],
          'email': user.email,
        };
      }
    } catch (e) {
      log.e("Error in getCurrentUserName: $e, Type: ${e.runtimeType}");
    }
    return {};
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final cred = EmailAuthProvider.credential(
            email: user.email!, password: currentPassword);
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword);
        log.i("Password changed successfully.");
        return true;
      }
    } catch (e) {
      log.e("Error in changePassword: $e, Type: ${e.runtimeType}");
    }
    return false;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log.e("Error in signout: $e, Type: ${e.runtimeType}");
    }
  }

  Future<void> updateProfileData(String name, String email) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('Users').doc(user.uid).update({
          'fName': name.split(" ")[0],
          'lName': name.split(" ")[1],
        });
        await user.updateEmail(email);
      }
    } catch (e) {
      log.e("Error in updateProfileData: $e, Type: ${e.runtimeType}");
    }
  }

  Future<List<Map<String, dynamic>>> getPatientsByCurrentUserUID() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Query to fetch all patients with the same UID as the current user
        final querySnapshot = await _firestore
            .collection('Patients')
            .where('UID', isEqualTo: user.uid)
            .get();

        log.i("Fetching patients for UID: ${user.uid}");

        // Map each document to a list of patient data
        return querySnapshot.docs.map((doc) {
          return {
            'id': doc.id, // Document ID for further reference
            'age': doc['Age'],
            'birthDate': doc['Birth_Date'],
            'firstName': doc['FName'],
            'lastName': doc['LName'],
            'gender': doc['gender'],
            'phoneNumber': doc['phoneNumber'],
            'uid': doc['UID'],
          };
        }).toList();
      } else {
        log.i("No user is logged in.");
      }
    } catch (e) {
      log.e("Error in getPatientsByCurrentUserUID: $e, Type: ${e.runtimeType}");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getPatientDiagnosisByPatientPID(
      String PID) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Query to fetch all patients with the same UID as the current user
        final querySnapshot = await _firestore
            .collection('Diagnosis')
            .where('PID', isEqualTo: PID)
            .get();

        log.i("Fetching patients Diagnosis with PID: $PID");

        // Map each document to a list of patient data
        return querySnapshot.docs.map((doc) {
          return {
            'id': doc.id, // Document ID for further reference
            'Diagnosis': doc['Diagnosis'],
            'Diagnosis_Date': doc['Diagnosis_Date'],
            'Image_Path': doc['Image_Path'],
            'PID': doc['PID'],
            'label': doc['label'],
          };
        }).toList();
      } else {
        log.i("No user is logged in.");
      }
    } catch (e) {
      log.e("Error in getPatientDiagnosisByPID: $e, Type: ${e.runtimeType}");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getCurrentUserPatientsFullDetails() async {
    // Fetch patients associated with the current user
    final patients = await getPatientsByCurrentUserUID();

    // Fetch all diagnoses in parallel using Future.wait
    final fullDetails = await Future.wait(patients.map((patient) async {
      final diagnosis = await getPatientDiagnosisByPatientPID(patient['id']);
      return {'patient': patient, 'diagnosis': diagnosis};
    }));
    log.i("Full Details: $fullDetails");
    return fullDetails;
  }

  Future<String> createNewPatient(String fName, String lName,
      DateTime birthDate, String gender, String phoneNumber, int age) async {
    try {
      // Create a new document in the Patients collection
      final newPatientRef = _firestore.collection('Patients').doc();

      final patientData = {
        'id': newPatientRef.id, // Assign the document ID
        'FName': fName,
        'LName': lName,
        'Birth_Date': birthDate,
        'gender': gender,
        'Age': age,
        'phoneNumber': phoneNumber,
        'UID': _auth.currentUser!.uid,
      };

      // Add the patient data
      await newPatientRef.set(patientData);
      log.i('Added new patient: ${newPatientRef.id}');
      return newPatientRef.id;
    } catch (e) {
      log.e('Error adding new patient: $e');
    }
    return "";
  }

  Future<int> getNewID(String PID) async {
    // Fetch the largest ID for the given PID
    final querySnapshot = await _firestore
        .collection('Diagnosis')
        .where('PID', isEqualTo: PID) // Ensure correct variable is used
        .get();

    int maxId = 0;
    for (var doc in querySnapshot.docs) {
      // Safely extract and parse the 'id' field
      final docId = doc.data()['id'] as int? ?? 0;
      if (docId > maxId) {
        maxId = docId;
      }
    }

    return maxId + 1; // Increment the max ID
  }

  Future<void> addDiagnosis(List<Map<String, dynamic>>? diagnosisList) async {
    try {
      for (var diagnosis in diagnosisList ?? []) {
        final pid = diagnosis['PID'];

        int newId = 0;
        newId = await getNewID(pid);

        final diagnosisRef = _firestore.collection('Diagnosis').doc();
        final date = DateTime.now();

        // Prepare diagnosis data
        final diagnosisData = {
          'id': newId, // Use the new ID
          'PID': pid,
          'Diagnosis': diagnosis['Diagnosis'],
          'Diagnosis_Date': date,
          'label': diagnosis['label'],
          'ModelType': diagnosis['ModelType'],
        };

        // Add data to Firestore
        await diagnosisRef.set(diagnosisData);
        log.i('Added diagnosis with ID: $newId for patient: $pid');
      }
    } catch (e, stackTrace) {
      log.e('Error adding diagnosis: $e');
      log.e('Stack trace: $stackTrace');
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      await _firestore.collection('Patients').doc(patientId).delete();
      log.i('Deleted patient: $patientId');
    } catch (e) {
      log.e('Error deleting patient: $e');
    }
  }

  Future<bool> feedback(String text, String text3, int rating) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final feedbackRef = _firestore.collection('Feedback').doc();
        final feedbackData = {
          'id': feedbackRef.id,
          'Name': text,
          'Feedback': text3,
          'Rating': rating,
        };

        await feedbackRef.set(feedbackData);
        log.i('Feedback submitted: ${feedbackRef.id}');
        return true;
      }
    } catch (e) {
      log.e('Error in feedback: $e');
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> fetchDiagnoses(String PID) async {
    try {
      // Query Firestore for diagnoses matching the given PID
      final querySnapshot = await _firestore
          .collection('Diagnosis')
          .where('PID', isEqualTo: PID)
          .orderBy('Diagnosis_Date', descending: true) // Optional: Order by date
          .get();

      // Extract and return the data as a list of maps
      final diagnoses = querySnapshot.docs.map((doc) {
        return {
          ...doc.data(), // Include the document data
          'docId': doc.id // Optionally include the document ID
        } as Map<String, dynamic>;
      }).toList();

      return diagnoses;
    } catch (e, stackTrace) {
      log.e('Error fetching diagnoses for PID $PID: $e');
      log.e('Stack trace: $stackTrace');
      return []; // Return an empty list if there's an error
    }
  }

  Future<int> getNumberOfPatientsForCurrentUser() async {
    final patients = await getPatientsByCurrentUserUID();
    return patients.length;
  }

  Future<int> getNumberOfFemalePatients() async {
    final patients = await getPatientsByCurrentUserUID();
    return patients.where((patient) => patient['gender']?.toLowerCase() == 'female').length;
  }

  Future<int> getNumberOfMalePatients() async {
    final patients = await getPatientsByCurrentUserUID();
    return patients.where((patient) => patient['gender']?.toLowerCase() == 'male').length;
  }

  Future<double> getAverageAgeOfPatients() async {
    final patients = await getPatientsByCurrentUserUID();
    if (patients.isEmpty) return 0.0;

    final totalAge = patients.fold<int>(
        0, (sum, patient) => sum + (patient['age'] as int? ?? 0));
    return totalAge / patients.length;
  }

}
