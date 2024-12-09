import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// EZZ
// https://concrete-grub-immensely.ngrok-free.app
// 2pDPe8ogpPOBHqz4nBgLkAcDbZ4_82p96Bo7vdpmcvDtKAWFN

// Shefo
// https://beloved-simply-piglet.ngrok-free.app
// 2pMS326VkCAcdJvvQsNGyAJbJSq_7oKjcn4FoEvS5ersmd5Ch

// to run NGROK: ngrok http --url=concrete-grub-immensely.ngrok-free.app 5000

final String flaskServerUrl = "https://concrete-grub-immensely.ngrok-free.app";
final String ngrokAuthKey = "2pDPe8ogpPOBHqz4nBgLkAcDbZ4_82p96Bo7vdpmcvDtKAWFN";

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User?> createUserWithEmailAndPassword(
      String fName, String lName, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Get the user ID (UID)
      String userId = cred.user!.uid;

      // Save additional user data in Realtime Database
      await _firestore.collection('Users').doc(userId).set({
        'fName': fName,
        'lName': lName,
        'profileImagePath':
            'https://static.vecteezy.com/system/resources/thumbnails/005/544/718/small/profile-icon-design-free-vector.jpg',
      });

      log("User registered and data saved successfully.");
      return cred.user;
    } catch (e) {
      log("Error in createUserWithEmailAndPassword: $e, Type: ${e.runtimeType}");
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
      log("Error in loginUserWithEmailAndPassword: $e, Type: ${e.runtimeType}");
    }
    return null;
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('Users').doc(user.uid).get();
        log("UserID: ${user.uid}, Requested Current User's Data.");
        return {
          'userFirstName': doc['fName'],
          'userLastName': doc['lName'],
          'email': user.email,
          'profileImagePath': doc['profileImagePath']
        };
      }
    } catch (e) {
      log("Error in getCurrentUserName: $e, Type: ${e.runtimeType}");
    }
    return {};
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Error in signout: $e, Type: ${e.runtimeType}");
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
      log("Error in updateProfileData: $e, Type: ${e.runtimeType}");
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

        log("Fetching patients for UID: ${user.uid}");

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
        log("No user is logged in.");
      }
    } catch (e) {
      log("Error in getPatientsByCurrentUserUID: $e, Type: ${e.runtimeType}");
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

        log("Fetching patients Diagnosis with PID: $PID");

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
        log("No user is logged in.");
      }
    } catch (e) {
      log("Error in getPatientDiagnosisByPID: $e, Type: ${e.runtimeType}");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getCurrentUserPatientsFullDetails() async {
    final patients = await getPatientsByCurrentUserUID();
    List<Map<String, dynamic>> fullDetails = [];
    for (var patient in patients) {
      final diagnosis = await getPatientDiagnosisByPatientPID(patient['id']);
      fullDetails.add({'patient': patient, 'diagnosis': diagnosis});
    }
    log("Full Details: $fullDetails");
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
      log('Added new patient: ${newPatientRef.id}');
      return newPatientRef.id;
    } catch (e) {
      log('Error adding new patient: $e');
    }
    return "";
  }

  Future<void> addDiagnosis(
      String patientId, List<Map<String, dynamic>>? diagnosisList) async {
    try {
      for (var diagnosis in diagnosisList ?? []) {
        final diagnosisRef = _firestore.collection('Diagnosis').doc();
        final diagnosisData = {
          'id': diagnosisRef.id,
          'PID': patientId,
          'Diagnosis': diagnosis['Diagnosis'],
          'Diagnosis_Date': diagnosis['Diagnosis_Date'],
          'Image_Path': diagnosis['Image_Path'],
          'label': diagnosis['label'],
        };

        await diagnosisRef.set(diagnosisData);
        log('Added diagnosis: ${diagnosisRef.id} for patient: $patientId');
      }
    } catch (e) {
      log('Error adding diagnosis: $e');
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      await _firestore.collection('Patients').doc(patientId).delete();
      log('Deleted patient: $patientId');
    } catch (e) {
      log('Error deleting patient: $e');
    }
  }
}
