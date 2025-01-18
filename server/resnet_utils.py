import numpy as np
import tensorflow as tf
from keras.preprocessing import image

# Load models
model_elbow_frac = tf.keras.models.load_model("weights/ResNet50_Elbow_frac.h5")
model_hand_frac = tf.keras.models.load_model("weights/ResNet50_Hand_frac.h5")
model_shoulder_frac = tf.keras.models.load_model("weights/ResNet50_Shoulder_frac.h5")
model_parts = tf.keras.models.load_model("weights/ResNet50_BodyParts.h5")

# Categories
categories_parts = ["Elbow", "Hand", "Shoulder"]
categories_fracture = ['fractured', 'normal']

# Prediction function
def predict(img_path, model="Parts"):

    size = 224
    # Choose the model
    if model == 'Parts':
        chosen_model = model_parts
    elif model == 'Elbow':
        chosen_model = model_elbow_frac
    elif model == 'Hand':
        chosen_model = model_hand_frac
    elif model == 'Shoulder':
        chosen_model = model_shoulder_frac
    else:
        raise ValueError(f"Invalid model name: {model}")

    # Preprocess the image
    temp_img = image.load_img(img_path, target_size=(size, size))
    x = image.img_to_array(temp_img)
    x = np.expand_dims(x, axis=0)  # Add batch dimension

    # Make prediction
    prediction = np.argmax(chosen_model.predict(x), axis=1)

    # Return category
    return (categories_parts if model == 'Parts' else categories_fracture)[prediction.item()]