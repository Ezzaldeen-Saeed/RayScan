import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        };
      }
    } catch (e) {
      log("Error in getCurrentUserName: $e, Type: ${e.runtimeType}");
    }
    return {};
  }

  //this method is for changing the password of the user by sending the current password and the new password
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final cred = EmailAuthProvider.credential(
            email: user.email!, password: currentPassword);
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword);
        log("Password changed successfully.");
        return true;
      }
    } catch (e) {
      log("Error in changePassword: $e, Type: ${e.runtimeType}");
    }
    return false;
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
    // Fetch patients associated with the current user
    final patients = await getPatientsByCurrentUserUID();

    // Fetch all diagnoses in parallel using Future.wait
    final fullDetails = await Future.wait(patients.map((patient) async {
      final diagnosis = await getPatientDiagnosisByPatientPID(patient['id']);
      return {'patient': patient, 'diagnosis': diagnosis};
    }));
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

  Future<int> getNewID(String PID) async {
    // Fetch the largest ID for the given PID
    final querySnapshot = await _firestore
        .collection('Diagnosis')
        .where('PID', isEqualTo: pid)
        .get();

    int maxId = 0;
    for (var doc in querySnapshot.docs) {
      final docId = doc.data()['id'];
      if (docId is int && docId > maxId) {
        maxId = docId;
      }
    }

    final newId = maxId + 1;
    return newId;
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
          'Image_Path': '', // Default to empty string if no image
          'label': diagnosis['label'],
          'ModelType': diagnosis['ModelType'],
        };

        // Add data to Firestore
        await diagnosisRef.set(diagnosisData);
        log('Added diagnosis with ID: $newId for patient: $pid');
      }
    } catch (e, stackTrace) {
      log('Error adding diagnosis: $e');
      log('Stack trace: $stackTrace');
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
        log('Feedback submitted: ${feedbackRef.id}');
        return true;
      }
    } catch (e) {
      log('Error in feedback: $e');
    }
    return false;
  }
}
