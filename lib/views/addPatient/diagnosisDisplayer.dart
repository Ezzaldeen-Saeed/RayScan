import 'dart:io';

import 'package:flutter/material.dart';
import 'package:testnav/widgets/pallet.dart';

class Diagnosisdisplayer_subView extends StatefulWidget {
  final Map<String, dynamic>? data;

  const Diagnosisdisplayer_subView({super.key, this.data});

  @override
  State<Diagnosisdisplayer_subView> createState() =>
      _Diagnosisdisplayer_subViewState();
}

class _Diagnosisdisplayer_subViewState
    extends State<Diagnosisdisplayer_subView> {
  File? _selectedImage;
  String topPrediction = "";
  double topPredictionPercentage = 0.0;

  void initState() {
    super.initState();
    _selectedImage = File(widget.data?["image"]);
    // get the highest prediction
    // example on the data
    // Top Predictions: Cardiomegaly: 0.9996, Effusion: 0.9656, Pleural_Thickening: 0.6952
    topPrediction = getHighestPrediction(widget.data?["data"]);
    topPredictionPercentage = double.parse(topPrediction.split(":")[1]);
    topPrediction = topPrediction.split(":")[0];
    topPredictionPercentage =
        (topPredictionPercentage * 100).floorToDouble() / 100;
    topPredictionPercentage = (topPredictionPercentage * 100);
  }

  String getHighestPrediction(String predictionString) {
    // Remove the initial "Top Predictions: " part
    String cleanString =
        predictionString.replaceFirst("Top Predictions: ", "").trim();

    // Split by commas to separate the predictions
    List<String> predictions = cleanString.split(", ");

    // Initialize variables to track the highest percentage
    String highestCondition = "";
    double highestValue = 0.0;

    // Iterate through each prediction
    for (String prediction in predictions) {
      // Split by colon to get the condition and its value
      List<String> parts = prediction.split(": ");
      String condition = parts[0];
      double value = double.parse(parts[1]);

      // Update the highest if this value is greater
      if (value > highestValue) {
        highestCondition = condition;
        highestValue = value;
      }
    }

    // Return the condition with the highest value
    return "$highestCondition: $highestValue";
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
          title: CustomText("Diagnosis Analysis", 1)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              CustomText("Diagnosis Analysis", 2),
              const SizedBox(height: 20),
              Text(
                  "${widget.data?["Gender"] == 'Male' ? "Mr." : "Ms."} ${widget.data?["FullName"]}"),
              const SizedBox(height: 20),

              // Display the Image
              if (_selectedImage != null) ...[
                Center(
                  child: Image.file(
                    _selectedImage!,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              CustomText("According to our analysis You Might Have ", 2),
              CustomText("$topPrediction : $topPredictionPercentage %", 2),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
