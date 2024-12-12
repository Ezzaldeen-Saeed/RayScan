import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/selectbox.dart';
import 'package:testnav/widgets/selectdate.dart';
import 'package:testnav/widgets/textfield.dart';

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
      appBar: AppBar(title: const Text("Add Patient")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                  hint: "John",
                  label: "First Name",
                  controller: _firstNameController),
              const SizedBox(height: 10),
              CustomTextField(
                  hint: "Doe",
                  label: "Last Name",
                  controller: _lastNameController),
              const SizedBox(height: 10),
              CustomDateSelection(
                label: "Birth Date",
                onDateSelected: (date) {
                  setState(() {
                    _birthDateController.text = date.toString();
                  });
                },
              ),
              const SizedBox(height: 10),
              CustomSelectBox(
                items: const ["Male", "Female"],
                label: 'Gender',
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                  hint: "1234567890",
                  label: "Phone Number",
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Pick Image"),
                ),
              ),
              const SizedBox(height: 20),
              if (_selectedImage != null) ...[
                Center(
                  child: Image.file(
                    _selectedImage!,
                    height: 200,
                    fit: BoxFit.cover,
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
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _uploadData,
                  // Disable button when uploading
                  child: _isUploading
                      ? const CircularProgressIndicator(
                          color: Colors.white) // Spinner in button
                      : const Text("Upload Data"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
