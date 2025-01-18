import json
from flask import Flask, request, jsonify, Response
import os
import time
from flask_cors import CORS
import util
import pandas as pd
from tensorflow.keras.applications.densenet import DenseNet121
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from tensorflow.keras.models import Model
import torch
import torchvision.transforms as transforms
from PIL import Image
import resnet_utils

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests

# Base directory for uploads
BASE_UPLOAD_FOLDER = './uploads'
os.makedirs(BASE_UPLOAD_FOLDER, exist_ok=True)

# Define the labels (list of possible conditions)
labels = [
    'Cardiomegaly', 'Emphysema', 'Effusion', 'Hernia', 'Infiltration',
    'Mass', 'Nodule', 'Atelectasis', 'Pneumothorax', 'Pleural_Thickening',
    'Pneumonia', 'Fibrosis', 'Edema', 'Consolidation'
]

# Define the desired labels
desired_labels = ['Cardiomegaly', 'Atelectasis', 'Effusion', 'Fibrosis', 'Hernia']

# Load the model
base_model = DenseNet121(weights=None, include_top=False)
x = base_model.output
x = GlobalAveragePooling2D()(x)
predictions = Dense(len(labels), activation="sigmoid")(x)
model = Model(inputs=base_model.input, outputs=predictions)

# Load the dataframe
df = pd.read_csv("train-small.csv")

# Load pretrained weights
MODEL_PATH = "weights/chest_x-ray_model.h5"
model.load_weights(MODEL_PATH)

@app.route('/upload', methods=['POST'])
def upload():
    token = request.headers.get('Authorization')
    if token != 'Temp_Token':   # Token for ngrock
        return jsonify({"error": "Unauthorized"}), 401

    # Get the model type from the request
    model_type = request.form.get('model_type')
    if not model_type:
        return jsonify({"error": "Missing required field: model_type"}), 400

    pid = request.form.get('PID')
    if not pid:
        return jsonify({"error": "Missing required field: PID"}), 400

    if 'file' not in request.files:
        return jsonify({"error": "No file part in the request"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    # Save the uploaded file
    patient_folder = os.path.join(BASE_UPLOAD_FOLDER, pid)
    os.makedirs(patient_folder, exist_ok=True)

    file_path = os.path.join(patient_folder, file.filename)
    file.save(file_path)

    # Validate if image is X-ray
    is_xray = util.val_image(file_path)
    if is_xray == 'X-ray':
        def generate_responses():
            yield f"data: {json.dumps({'message': 'Image Received'})}\n\n"
            time.sleep(1)

            yield f"data: {json.dumps({'message': 'Processing Image'})}\n\n"
            time.sleep(1)

            try:
                if model_type == "chest":
                    # Process the image for the chest disease model
                    all_predictions = util.process_sender_image(file_path, df, model, labels, threshold=0.7)

                    # Filter predictions for desired labels, setting missing ones to 0
                    filtered_predictions = {label: all_predictions.get(label, 0) for label in desired_labels}

                    # Convert all values to float to make them JSON serializable
                    sorted_predictions = {label: float(prob) for label, prob in sorted(filtered_predictions.items(), key=lambda item: item[1], reverse=True)}

                    if sorted_predictions:
                        yield f"data: {json.dumps({'message': 'Processing Complete', 'top_predictions': sorted_predictions})}\n\n"
                    else:
                        yield f"data: {json.dumps({'message': 'Processing Complete, but no results found'})}\n\n"


                elif model_type == "bone fracture":
                    try:
                        # Predict the bone type
                        bone_type = resnet_utils.predict(file_path, model="Parts")

                        # Predict whether the bone is fractured
                        fracture_status = resnet_utils.predict(file_path, model=bone_type)

                        # Prepare the response
                        result = {
                            "bone_type": bone_type,
                            "fracture_status": fracture_status
                        }

                        # Send the response
                        yield f"data: {json.dumps({'message': 'Processing Complete', 'top_predictions': result})}\n\n"

                    except Exception as e:
                        print(f"Error during bone fracture processing: {str(e)}")
                        yield f"data: {json.dumps({'message': 'Error', 'details': str(e)})}\n\n"

                else:
                    yield f"data: {json.dumps({'message': 'Error', 'details': 'Invalid model_type specified'})}\n\n"

            except Exception as e:
                print(f"Error during image processing: {str(e)}")
                yield f"data: {json.dumps({'message': 'Error', 'details': str(e)})}\n\n"

        return Response(generate_responses(), content_type='text/event-stream')

    else:
        return jsonify({"error": "This image is not a valid x-ray. Please try another image."}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
