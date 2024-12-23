import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiagnosisSelector extends StatefulWidget {
  @override
  _DiagnosisSelectorState createState() => _DiagnosisSelectorState();
}

class _DiagnosisSelectorState extends State<DiagnosisSelector> {
  // List of options
  final List<Map<String, dynamic>> _options = [
    {"label": "Cardiomegaly", "value": 1},
    {"label": "Hernia", "value": 2},
    {"label": "Atelectasis", "value": 3},
    {"label": "Fibrosis", "value": 4},
    {"label": "Effusion", "value": 5},
    {"label": "NO Lung Disease", "value": 6},
    {"label": "Shoulder Fracture", "value": 7},
    {"label": "NO Shoulder Fracture", "value": 8},
    {"label": "Elbow Fracture", "value": 9},
    {"label": "NO Elbow Fracture", "value": 10},
    {"label": "Wrist Fracture", "value": 11},
    {"label": "NO Wrist Fracture", "value": 12},
  ];

  // Selected option
  int? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      isExpanded: true,
      // Makes the dropdown take full width
      value: _selectedValue,
      // Currently selected value
      hint: Text("Select a Diagnosis"),
      // Placeholder
      items: _options.map((option) {
        return DropdownMenuItem<int>(
          value: option["value"],
          child: Text(option["label"]),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          _selectedValue = newValue;
        });

        // Call the corresponding method
        if (newValue != null) {
          _testuploadData(newValue);
        }
      },
    );
  }

  void _testuploadData(int type) {
    Map<String, dynamic> data = {"": ""};
    String modelType = "", pid = "", fullName = "", gender = "", path = "";
    switch (type) {
      case 1:
        data = {
          "Cardiomegaly": 0.95,
          "Effusion": 0.00,
          "Atelectasis": 0.00,
        };
        modelType = "chest";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 2:
        data = {
          "Hernia": 0.75,
          "Cardiomegaly": 0.00,
          "Atelectasis": 0.00,
        };
        modelType = "chest";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 3:
        data = {
          "Atelectasis": 0.80,
          "Hernia": 0.00,
          "Cardiomegaly": 0.00,
        };
        modelType = "chest";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 4:
        data = {
          "Fibrosis": 0.78,
          "Hernia": 0.00,
          "Atelectasis": 0.00,
        };
        modelType = "chest";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 5:
        data = {
          "Effusion": 0.88,
          "Hernia": 0.00,
          "Atelectasis": 0.00,
        };
        modelType = "chest";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 6:
        data = {
          "Cardio": 0.00,
          "Hernia": 0.00,
          "Atelectasis": 0.00,
        };
        modelType = "chest";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 7:
        data = {"bone_type": "Shoulder", "fracture_status": "fractured"};
        modelType = "bone fracture";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 8:
        data = {"bone_type": "Shoulder", "fracture_status": "normal"};
        modelType = "bone fracture";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 9:
        data = {"bone_type": "Elbow", "fracture_status": "fractured"};
        modelType = "bone fracture";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 10:
        data = {"bone_type": "Elbow", "fracture_status": "normal"};
        modelType = "bone fracture";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 11:
        data = {"bone_type": "Wrist", "fracture_status": "fractured"};
        modelType = "bone fracture";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
      case 12:
        data = {"bone_type": "Wrist", "fracture_status": "normal"};
        modelType = "bone fracture";
        pid = "LOL";
        fullName = "Lolo Man";
        gender = "Male";
        break;
    }
    context.go("/addPatient/diagnosisDisplayer_subview", extra: {
      "data": data,
      "ModelType": modelType,
      "DOB": "2003-7-5",
      "PID": pid,
      "FullName": fullName,
      "Gender": gender,
      "image":
          "/data/user/0/com.example.testnav/cache/77bfcbdd-b0f3-4283-af67-8c46dc6b4ef3/effusion_test_2.png",
    });
  }
}
