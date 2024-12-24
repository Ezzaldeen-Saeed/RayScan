import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/widgets/pallet.dart';
import 'package:http/http.dart' as http;
import 'package:testnav/views/addPatient/diagnosisDisplayer.dart';

class CustomDialog extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onContinue;
  final VoidCallback onHintTap;
  final Color backgroundColor;
  final Color fontColor;
  final bool hasHint;
  final String title;
  final Widget continueButtonChild;
  final IconData hintIcon;
  final bool hasBackOption;

  const CustomDialog({
    Key? key,
    this.animation = const AlwaysStoppedAnimation(1),
    required this.onContinue,
    this.hintIcon = Icons.error_outline,
    this.hasHint = false,
    this.hasBackOption = false,
    required this.onHintTap,
    required this.backgroundColor,
    required this.fontColor,
    required this.title,
    required this.continueButtonChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textAlign: TextAlign.center,
              title,
              style: TextStyle(
                color: fontColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            hasHint
                ? GestureDetector(
                    onTap: onHintTap,
                    child: ScaleTransition(
                      scale: animation,
                      child: Icon(
                        hintIcon,
                        size: 30,
                        color: fontColor,
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fontColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: continueButtonChild,
                ),
                const Spacer(),
                hasBackOption
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: confirmAlertDialogCancelBG,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: confirmAlertDialogCancelFont),
                        ),
                      )
                    : const SizedBox(),
                hasBackOption ? const Spacer() : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosisCustomDialog extends StatefulWidget {
  final String PID, gender, fName, lName, DOB;
  BuildContext mainContext;

  DiagnosisCustomDialog({
    super.key,
    required this.PID,
    required this.gender,
    required this.fName,
    required this.lName,
    required this.DOB,
    required this.mainContext,
  });

  @override
  State<DiagnosisCustomDialog> createState() => _DiagnosisCustomDialogState();
}

class _DiagnosisCustomDialogState extends State<DiagnosisCustomDialog> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String _selectedModelType = "";
  String _responseMessage = "";
  bool _isUploading = false;
  Text text = Text("");

  Future<void> _uploadData() async {
    final Logger log = Logger(
      printer: PrettyPrinter(),
      output: null,
    );

    String url = "$flaskServerUrl/upload";
    final uri = Uri.parse(url);

    if (_selectedImage == null) {
      setState(() {
        _responseMessage = "Please select an image first.";
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
      request.fields['PID'] = widget.PID;
      request.fields['model_type'] = _selectedModelType;

      String ID = await widget.PID;
      int newId = await _auth.getNewID(ID);
      log.i("ID : $newId");



      String filePath = _selectedImage!.path;
      String fileExtension = filePath.split('.').last;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
          filename: "$newId.$fileExtension",
        ),
      );

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final stream = streamedResponse.stream.transform(utf8.decoder);

        await for (final line in stream) {
          if (line.startsWith("data:")) {
            final jsonData = line.substring(5).trim();

            try {
              final response = json.decode(jsonData);

              if (response.containsKey("message")) {
                setState(() {
                  text = Text(response["message"]);
                  _responseMessage = response["message"];
                });
                log.i("Server Response: ${response["message"]}");

                // Check if top_prediction exists (or any other field you're expecting)
                if (response.containsKey("top_predictions")) {
                  log.i(response);
                  if (response.containsKey("top_predictions")) {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Diagnosisdisplayer_subView(
                                  data: {
                                    "data": response["top_predictions"],
                                    "PID": widget.PID,
                                    "DOB": widget.DOB,
                                    "FullName":
                                        "${widget.fName} ${widget.lName}",
                                    "Gender": widget.gender,
                                    "ModelType": _selectedModelType,
                                    "image": _selectedImage!.path,
                                  },
                                )));
                  }
                }
              } else {
                log.e("No 'message' found in the response.");
              }
            } catch (e) {
              log.e("Error decoding JSON: $e");
              setState(() {
                _responseMessage =
                    "Error decoding server response. Please try again.";
              });
            }
          }
        }
      } else {
        setState(() {
          _responseMessage = "Upload failed: ${streamedResponse.statusCode}";
        });
        log.e("Upload failed: ${streamedResponse.statusCode}");
      }
    } catch (e) {
      setState(() {
        _responseMessage = "An error occurred: $e";
      });
      log.e("An error occurred: $e");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                enabled: false,
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  final XFile? pickedImage =
                      await _imagePicker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _selectedImage =
                          File(pickedImage.path); // Convert to File
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  final XFile? pickedImage =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _selectedImage =
                          File(pickedImage.path); // Convert to File.
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: confirmAlertDialogBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Upload New Diagnosis",
                style: TextStyle(
                  color: confirmAlertDialogFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_selectedImage == null)
                GestureDetector(
                  onTap: _showImageSourceActionSheet,
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
              const SizedBox(height: 16),
              if (_selectedImage != null &&
                  (!_isUploading || _responseMessage != "")) ...[
                Center(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
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
              !_isUploading
                  ? Row(
                      children: [
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            _selectedModelType = "bone fracture";
                            _uploadData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: confirmAlertDialogFont,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Bone Fracture",
                            style: TextStyle(color: confirmAlertDialogBg),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            _selectedModelType = "chest";
                            _uploadData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: confirmAlertDialogFont,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Chest",
                            style: TextStyle(color: confirmAlertDialogBg),
                          ),
                        ),
                        Spacer(),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 16),
              if (_isUploading)
                Column(
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      "Uploading, please wait...",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              if (!_isUploading && _responseMessage.isNotEmpty)
                Column(
                  children: [
                    Text(
                      _responseMessage,
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    const SizedBox(height: 10),
                    text, // Display server response message
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
