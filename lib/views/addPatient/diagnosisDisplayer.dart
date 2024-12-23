import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testnav/auth/auth_service.dart';
import 'package:testnav/utils/Utility.dart';
import 'package:testnav/widgets/customDialog.dart';
import 'package:testnav/widgets/customSnackbar.dart';
import 'package:testnav/widgets/incrementingAnimation.dart';
import 'package:testnav/widgets/pallet.dart';

class Diagnosisdisplayer_subView extends StatefulWidget {
  final Map<String, dynamic>? data;

  Diagnosisdisplayer_subView({super.key, this.data});

  @override
  State<Diagnosisdisplayer_subView> createState() =>
      _Diagnosisdisplayer_subViewState();
}

class _Diagnosisdisplayer_subViewState
    extends State<Diagnosisdisplayer_subView> {
  final AuthService _auth = AuthService();
  final downloadService = DownloadServices();
  File? _selectedImage;
  String topPrediction = "";
  double topPredictionPercentage = 0.0;
  String fractureStatus = "";
  String fracturePlace = "";
  String modelType = "";
  bool _isFabVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isFabVisible = true;
      });
    });

    // Get the image path safely
    String? imagePath = widget.data?["image"];
    if (imagePath != null && imagePath.isNotEmpty) {
      _selectedImage = File(imagePath);
    }

    // Handle top predictions
    final Map<String, dynamic>? predictions;
    modelType = (widget.data?["ModelType"] as String?)!;
    log("model type = $modelType");
    predictions = widget.data?["data"] as Map<String, dynamic>?;
    if (modelType == "chest") {
      if (predictions != null) {
        final highestPrediction = getHighestPrediction(predictions);
        topPrediction = highestPrediction["condition"];
        topPredictionPercentage = (highestPrediction["value"] * 100)
            .floorToDouble(); // Round to two decimal places
        Map<String, dynamic> diagnosisData = {
          'PID': widget.data?["PID"],
          'Diagnosis': predictions,
          'label': topPrediction,
          'ModelType': modelType,
        };

        _auth.addDiagnosis([diagnosisData]);
      }
    } else if (modelType == "bone fracture") {
      if (predictions != null) {
        fracturePlace = predictions["bone_type"];
        fractureStatus = predictions["fracture_status"];
        // fractureStatus == "fractured"
        // ?
        // :  ,
      }
    }
  }

  Map<String, dynamic> getHighestPrediction(Map<String, dynamic> predictions) {
    String highestCondition = "";
    double highestValue = 0.0;
    predictions.forEach((condition, value) {
      if (value is double && value > highestValue) {
        highestCondition = condition;
        highestValue = value;
      }
    });
    return {
      "condition": highestCondition,
      "value": highestValue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: CustomText("Diagnosis Analysis", 1.0),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outlined,
              color: primaryColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return CustomDialog(
                    onContinue: () {
                      Navigator.of(context).pop();
                    },
                    onHintTap: () {},
                    backgroundColor: infoAlertDialogBg,
                    fontColor: infoAlertDialogFont,
                    title:
                        'This diagnosis is not 100% accurate. You must visit a medical professional for confirmation.',
                    continueButtonChild: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    hasHint: false,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "${widget.data?["Gender"] == 'Male' ? "Mr." : "Ms."} ${widget.data?["FullName"]}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedImage != null) ...[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            _selectedImage!,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 80,
                  ),
                  modelType == "chest"
                      ? Column(
                          children: [
                            Text(
                              topPredictionPercentage > 0
                                  ? "According to our analysis, you might have:"
                                  : "According to our analysis, you don't have any of the deceases that our model can detect.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            AnimatedPercentage(
                              percentage: topPredictionPercentage,
                              topPrediction: topPrediction,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              "This X-Ray image belongs to:",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "$fracturePlace and is $fractureStatus",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: fractureStatus == "fractured"
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            bottom: _isFabVisible ? 20 : -60, // Starts off-screen
            right: _isFabVisible ? 20 : -60,
            child: FloatingActionButton(
              onPressed: () async {
                final patientData = {
                  "FullName": widget.data?["FullName"],
                  "Gender": widget.data?["Gender"],
                  "DOB": widget.data?["DOB"],
                  "ModelType": widget.data?["ModelType"],
                  "Condition": topPrediction,
                  "boneStatus": fractureStatus,
                  "ConfidencePercentage": topPredictionPercentage,
                };
                if (await DownloadServices.generateAndSavePDF(patientData)) {
                  CustomSnackbar(
                          title: 'Report Saved in Downloads in PDF Form.',
                          backgroundColor: primaryColor,
                          fontColor: Colors.white)
                      .show(context);
                }
              },
              backgroundColor: primaryColor,
              child: const Icon(
                Icons.download_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}