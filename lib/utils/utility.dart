import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:testnav/Storage/hiveManager.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/pallet.dart';

class DarkModeController extends ChangeNotifier {
  bool _isDarkMode = darkMode;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    darkMode = _isDarkMode;
    hs.setDarkMode(darkMode);
    setCurrentTheme(darkMode);
    notifyListeners();
  }

  void setCurrentTheme(bool isDarkMode) {
    currentBG = isDarkMode ? darkModeBG1 : lightModeBG1;
    currentBG2 = isDarkMode ? darkModeBG2 : lightModeBG2;
    currentTextColor = isDarkMode ? textColorDarkMode : textColorLightMode;
  }
}

class SignUpAndLogin {
  final _auth = AuthService();

  Future<bool> signup(BuildContext context, String firstName, String lastName,
      String email, String password) async {
    final user = await _auth.createUserWithEmailAndPassword(
        firstName, lastName, email, password);
    if (user != null) {
      print("User Created Succesfully");
      context.go('/login');
      return true;
    }
    return false;
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    final user = await _auth.loginUserWithEmailAndPassword(email, password);

    if (user != null) {
      print("User Logged In");
      HiveService().setLoginStatus(true);

      Map<String, dynamic>? data = await _auth.getCurrentUserData();
      if (data == null ||
          !data.containsKey('userFirstName') ||
          !data.containsKey('userLastName')) {
        print("Incomplete user data. Defaulting to placeholders.");
        HiveService().saveUserData("Guest", "", email, "");
      } else {
        String fName = data['userFirstName'] ?? "Guest";
        String lName = data['userLastName'] ?? "";
        String profileImagePath =
            await HiveService().getProfileImagePath() ?? "";

        HiveService().saveUserData(fName, lName, email, profileImagePath);
      }

      context.go('/home');
      return true;
    }

    print("Login failed for email: $email");
    return false;
  }

  Future<bool> signOut(BuildContext context) async {
    await _auth.signout();
    HiveService().setLoginStatus(false);
    HiveService().clearUserData();
    HiveService().clearAppCache();
    context.go('/login');
    return true;
  }
}

class RandomPatientGenerator {
  final List<String> firstNames = [
    'John',
    'Jane',
    'Michael',
    'Emily',
    'Chris',
    'Sarah',
    'David',
    'Anna'
  ];
  final List<String> lastNames = [
    'Smith',
    'Johnson',
    'Brown',
    'Williams',
    'Jones',
    'Miller',
    'Davis',
    'Garcia'
  ];
  final List<String> genders = ['Male', 'Female'];
  final Random random = Random();

  Map<String, dynamic> generateRandomPatient() {
    final String firstName = firstNames[random.nextInt(firstNames.length)];
    final String lastName = lastNames[random.nextInt(lastNames.length)];
    final String gender = genders[random.nextInt(genders.length)];
    final int age = random.nextInt(100); // Age between 0 and 99
    final String phone = List.generate(10, (_) => random.nextInt(10))
        .join(); // Generate 10-digit phone as string

    // Generate a valid random date for diagnosis
    final DateTime now = DateTime.now();
    final DateTime randomDate =
        now.subtract(Duration(days: random.nextInt(365 * 50))); // 50 years max
    final Timestamp diagnosisDate = Timestamp.fromDate(randomDate);

    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': DateTime(
          now.year - age, random.nextInt(12) + 1, random.nextInt(28) + 1),
      'gender': gender,
      'phone': phone,
      'age': age,
    };
  }
}

class DownloadServices {
  /// Generate a PDF with patient data and save it in the Downloads folder
  static Future<bool> generateAndSavePDF(
      Map<String, dynamic> patientData) async {
    try {
      // Create a PDF document
      final pdf = pw.Document();

      // Load the image from assets
      final ByteData data = await rootBundle.load('assets/others/app_icon.png');
      final imageBytes = data.buffer.asUint8List();
      final image = pw.MemoryImage(imageBytes);

      // Add content to the PDF
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Stack(
            children: [
              // Position the image in the top-right corner
              pw.Positioned(
                top: 0,
                right: 0,
                child: pw.Image(image,
                    width: 100, height: 100), // Adjust size as needed
              ),
              // Add the text content below
              pw.Positioned(
                top: 110,
                // Adjust this as needed to avoid overlapping with the image
                left: 0,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Patient Report",
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 20),
                    pw.Text("Name: ${patientData['FullName']}",
                        style: pw.TextStyle(fontSize: 16)),
                    pw.Text("Gender: ${patientData['Gender']}",
                        style: pw.TextStyle(fontSize: 16)),
                    pw.Text("Date of Birth: ${patientData['DOB']}",
                        style: pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 20),
                    pw.Text("Diagnosis Results:",
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    if (patientData['ModelType'] == "chest")
                      pw.Text(
                          "Top Prediction: ${patientData['Condition'] ?? 'N/A'}",
                          style: pw.TextStyle(fontSize: 16)),
                    if (patientData['ModelType'] == "chest")
                      pw.Text(
                          "Prediction Percentage: ${patientData['ConfidencePercentage'] ?? 'N/A'}%",
                          style: pw.TextStyle(fontSize: 16)),
                    if (patientData['ModelType'] == "bone fracture")
                      pw.Text(
                          "Bone Status: ${patientData['boneStatus'] ?? 'N/A'}",
                          style: pw.TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      // Get the Downloads directory
      final directory = await getExternalStorageDirectory();
      final downloadsPath =
          "${directory!.parent.parent.parent.parent.path}/Download";

      // Create a subfolder in the Downloads directory
      final customFolder = Directory("$downloadsPath/PatientReports");
      if (!customFolder.existsSync()) {
        customFolder.createSync(recursive: true);
      }

      // Define the file path
      final filePath =
          "${customFolder.path}/${patientData['FullName']}_Report.pdf";

      // Save the PDF file
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      print("PDF saved successfully at $filePath");
      return true;
    } catch (e) {
      print("Error saving PDF: $e");
    }
    return false;
  }
}

class DataUploader {
  final Logger log = Logger(
    // filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  DataUploader();

  Future<void> uploadData({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String gender,
    required String phoneNumber,
    required String selectedModelType,
    required String? imagePath,
    required Future<String> patientIdFuture,
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required void Function(bool isUploading) setUploadingState,
    required void Function(String responseMessage) updateResponseMessage,
  }) async {
    int age = DateTime.now().year - birthDate.year;
    String url = "$flaskServerUrl/upload";
    final uri = Uri.parse(url);

    if (imagePath == null) {
      updateResponseMessage("Please select an image first.");
      return;
    }

    if (!formKey.currentState!.validate()) {
      updateResponseMessage("Please fill in all fields correctly.");
      return;
    }

    final headers = {
      'Authorization': ngrokAuthKey,
    };

    setUploadingState(true);

    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      // Add form fields
      request.fields['PID'] = await patientIdFuture;
      request.fields['model_type'] = selectedModelType;

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath('file', imagePath),
      );

      // Send the request
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final stream = streamedResponse.stream.transform(utf8.decoder);

        await for (final line in stream) {
          log.i("Raw line received: $line"); // Debug log to inspect raw data
          if (line.startsWith("data:")) {
            final jsonData = line.substring(5).trim(); // Clean the response

            try {
              final response = json.decode(jsonData);

              // Handle the response message
              if (response.containsKey("message")) {
                String responseMessage = response["message"];
                updateResponseMessage(responseMessage);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(responseMessage),
                  ),
                );
                log.i("Server Response: $responseMessage");

                // Navigate if top_predictions exist
                if (response.containsKey("top_predictions")) {
                  context.go("/addPatient/diagnosisDisplayer_subview", extra: {
                    "data": response["top_predictions"],
                    "PID": await patientIdFuture,
                    "DOB": birthDate.toIso8601String(),
                    "FullName": "$firstName $lastName",
                    "Gender": gender,
                    "ModelType": selectedModelType,
                    "image": imagePath,
                  });
                }
              } else {
                log.w("No 'message' found in the response.");
              }
            } catch (e) {
              log.e("Error decoding JSON: $e");
              updateResponseMessage(
                  "Error decoding server response. Please try again.");
            }
          }
        }
      } else {
        updateResponseMessage("Upload failed: ${streamedResponse.statusCode}");
        log.w("Upload failed: ${streamedResponse.statusCode}");
      }
    } catch (e) {
      updateResponseMessage("An error occurred: $e");
      log.e("An error occurred: $e");
    } finally {
      setUploadingState(false);
    }
  }
}
