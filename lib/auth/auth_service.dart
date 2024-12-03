import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
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
}
