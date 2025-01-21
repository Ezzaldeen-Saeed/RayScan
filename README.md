# RayScan - Mobile X-Ray Diagnostic App

## Overview

RayScan is a mobile application that leverages advanced machine learning techniques to diagnose chest X-rays and detect bone fractures in the arm region. Designed with **Dart**, this app provides a user-friendly interface for medical professionals and patients to quickly assess and identify abnormalities in X-ray images.

## Features

### Chest X-Ray Diagnosis

RayScan can detect the following diseases in chest X-rays:

- **Atelectasis**
- **Cardiomegaly**
- **Fibrosis**
- **Effusion**
- **Hernia**

### Bone Fracture Detection

For arm X-rays, the app can:

- Identify fractures
- Pinpoint the exact part of the arm that is fractured

## Technology Stack

- **Frontend**: Dart (Flutter)
- **Backend**: TensorFlow/Keras for model training (optional integration)
- **Deployment**: Compatible with Android and iOS

## Getting Started

### Prerequisites

Ensure you have the following installed:

- Flutter SDK
- Dart
- A device or emulator to run the application

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Ezzaldeen-Saeed/RayScan.git
   ```
2. Navigate to the project directory:
   ```bash
   cd RayScan
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

## Model Weights

The application requires pre-trained model weights to function correctly. Please download the weights from the link below and place them in the `server` directory.

**[Download Model Weights](https://drive.google.com/drive/folders/1xKQhWKL7N9gBCYLYbLwP5RQL4PVKwf3i?usp=sharing)**

## Datasets Used

**[Bone Fracture Dataset](https://www.kaggle.com/datasets/pkdarabi/bone-fracture-detection-computer-vision-project?select=bone+fracture+detection.v4-v4.yolov8)**

**[Chest Diseases Dataset](https://www.kaggle.com/datasets/nih-chest-xrays/data/data)**

## How It Works

1. Upload an X-ray image through the app.
2. Choose the type of analysis (Chest or Fracture).
3. Receive a detailed report with detected abnormalities or fractures.

