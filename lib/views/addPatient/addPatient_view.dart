import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/main.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:testnav/widgets/textfield.dart';
import 'package:testnav/widgets/toggleButton.dart';

class AddPatientView extends StatefulWidget {
  const AddPatientView({super.key});

  @override
  State<AddPatientView> createState() => _AddPatientViewState();
}

class _AddPatientViewState extends State<AddPatientView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _selectedGender;
  File? _selectedImage;
  String _responseMessage = "";
  bool _isUploading = false;

  final ImagePicker _imagePicker = ImagePicker();
  final AuthService _auth = AuthService();

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  List<bool> _isSelected = [true, false];

  Future<void> _uploadData() async {
    DateTime BD = DateTime.parse(_birthDateController.text);
    int age = DateTime.now().year - BD.year;
    Future<String> pid = _auth.createNewPatient(
        _firstNameController.text,
        _lastNameController.text,
        BD,
        _selectedGender!,
        _phoneNumberController.text,
        age);

    String url = "$flaskServerUrl/upload";
    final uri = Uri.parse(url);

    if (_selectedImage == null) {
      setState(() {
        _responseMessage = "Please select an image first.";
      });
      return;
    }

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _responseMessage = "Please fill in all fields correctly.";
      });
      return;
    }

    final headers = {
      'Authorization': ngrokAuthKey,
    };

    setState(() {
      _isUploading = true;
    });

    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      // Add form fields
      request.fields['PID'] = await pid;

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath('file', _selectedImage!.path),
      );

      // Send the request
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final stream = streamedResponse.stream.transform(utf8.decoder);
        await for (final line in stream) {
          if (line.startsWith("data:")) {
            final jsonData = line.substring(5).trim();

            try {
              final response = json.decode(jsonData);

              // Check if 'message' exists in the response
              if (response.containsKey("message")) {
                setState(() {
                  _responseMessage = response["message"];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_responseMessage),
                    ),
                  );
                });
                log("Server Response: ${response["message"]}");

                // Check if top_prediction exists (or any other field you're expecting)
                if (response.containsKey("top_predictions")) {
                  _responseMessage = response["top_predictions"];
                  log("Top Predictions: ${response["top_predictions"]}");
                  context.go("/addPatient/diagnosisDisplayer_subview", extra: {
                    "data": response["top_predictions"],
                    "PID": await pid,
                    "FullName":
                        "${_firstNameController.text} ${_lastNameController.text}",
                    "Gender": _selectedGender,
                    // send the image
                    "image": _selectedImage!.path,
                  });
                }
              } else {
                log("No message found in the response");
              }
            } catch (e) {
              log("Error decoding JSON: $e");
            }
          }
        }
      } else {
        setState(() {
          _responseMessage = "Upload failed: ${streamedResponse.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentBG,
      appBar: AppBar(
        backgroundColor: currentBG,
        surfaceTintColor: primaryColor,
        centerTitle: true,
        title: CustomText("Add Patient", 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText("First Name", 2),
              ),
              CustomTextFieldV2(
                type: 1.0,
                isPassword: false,
                controller: _firstNameController,
                hint: "Joe",
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText("Last Name", 2),
              ),
              CustomTextFieldV2(
                type: 1.0,
                isPassword: false,
                controller: _lastNameController,
                hint: "Doe",
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText("Phone Number", 2),
              ),
              CustomTextFieldV2(
                type: 1.0,
                isPassword: false,
                controller: _phoneNumberController,
                hint: "1234567890",
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText("Gender", 2),
              ),
              Center(
                child: CustomToggleButtons(
                  labels: ['Male', 'Female'],
                  isSelected: _isSelected,
                  onToggle: (int index) {
                    setState(() {
                      for (int i = 0; i < _isSelected.length; i++) {
                        _isSelected[i] = i == index;
                      }
                    });
                  },
                  padding: 16.0,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText("Date of Birth", 2),
              ),
              CustomTextFieldV2(
                  type: 1.0,
                  isPassword: false,
                  controller: _birthDateController,
                  hint: "DD/MM/YYYY"),
              const SizedBox(height: 20),
              if (_selectedImage == null)
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: textFieldBGColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: const Icon(Icons.file_upload_outlined,
                            color: primaryColor, size: 70),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (_selectedImage != null) ...[
                Center(
                  child: Stack(
                    children: [
                      // Display the image without BoxFit.cover
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                          // fit: BoxFit.cover, // Removed fit property
                        ),
                      ),
                      // Close button positioned on top-right of the image
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            // Semi-transparent background
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "File Name: ${_selectedImage!.path.split('/').last}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _isUploading ? null : _uploadData,
                  child: Container(
                    width: 170,
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: _isUploading ? Colors.grey : primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: _isUploading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : CustomText("Upload", 1, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
