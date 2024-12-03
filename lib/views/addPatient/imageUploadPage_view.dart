import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:testnav/auth/auth_service.dart';

class ImageUpload_subview extends StatefulWidget {
  @override
  _ImageUploadSubviewState createState() => _ImageUploadSubviewState();
}

class _ImageUploadSubviewState extends State<ImageUpload_subview> {
  late XFile _selectedImage = XFile("");
  final ImagePicker _picker = ImagePicker();
  String _responseMessage = "";

  // Pick a single image
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  Future<void> uploadImage() async {
    String url = "$flaskServerUrl/upload";
    log("Uploading images to: $url");
    log("Selected images: ${_selectedImage.path}");
    log("Ngrok Auth Key: $ngrokAuthKey");
    final uri = Uri.parse(url);

    if (_selectedImage.path.isEmpty) {
      setState(() {
        _responseMessage = "Please select an image first.";
      });
      return;
    }

    final headers = {
      'Authorization': ngrokAuthKey,
    };

    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(headers);
      request.files
          .add(await http.MultipartFile.fromPath('files', _selectedImage.path));

      // Send the request
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final stream = streamedResponse.stream.transform(utf8.decoder);
        await for (final line in stream) {
          if (line.startsWith("data:")) {
            final jsonData = line.substring(5).trim();
            final response = json.decode(jsonData);
            setState(() {
              _responseMessage = response["message"];
            });
            print("Server Message: ${response["message"]}");
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Uploader")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Pick Image", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            _selectedImage.path.isNotEmpty
                ? Text("Selected Image: ${_selectedImage.name}",
                    style: TextStyle(fontSize: 20))
                : Text("No images selected", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text("Upload Image", style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            Text(
              _responseMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
