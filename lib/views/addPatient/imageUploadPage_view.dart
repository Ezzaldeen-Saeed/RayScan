import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:testnav/auth/auth_service.dart';

class ImageUpload_subview extends StatefulWidget {
  @override
  _ImageUpload_subviewState createState() => _ImageUpload_subviewState();
}

class _ImageUpload_subviewState extends State<ImageUpload_subview> {
  List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  String _responseMessage = "";

  // Pick a single image
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(pickedFile);
      });
    }
  }

  Future<void> uploadImages() async {
    if (_selectedImages.isEmpty) {
      setState(() {
        _responseMessage = "No images selected.";
      });
      return;
    }

    final uri = Uri.parse("$flaskServerUrl/upload");

    try {
      var request = http.MultipartRequest('POST', uri);

      // Add the Ngrok Authorization token
      request.headers['Authorization'] = ngrokAuthKey;

      // Add images to the request
      for (var image in _selectedImages) {
        request.files
            .add(await http.MultipartFile.fromPath('files', image.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        setState(() {
          _responseMessage = responseData.body;
        });
      } else {
        setState(() {
          _responseMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = "Failed to upload images: $e";
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
            _selectedImages.isNotEmpty
                ? Text("Selected Images: ${_selectedImages.length}",
                    style: TextStyle(fontSize: 20))
                : Text("No images selected", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImages,
              child: Text("Upload Images", style: TextStyle(fontSize: 20)),
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
