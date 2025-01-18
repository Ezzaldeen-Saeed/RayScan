import random
import tensorflow as tf
import cv2
import matplotlib.pyplot as plt
import numpy as np
from keras import backend as K
from keras.preprocessing import image
from sklearn.metrics import roc_auc_score, roc_curve
from tensorflow.compat.v1.logging import INFO, set_verbosity
import pandas as pd
from PIL import Image
from skimage.feature import greycomatrix, greycoprops

random.seed(a=None, version=2)

set_verbosity(INFO)

# Gets Standard deviation and mean for the image
def get_mean_std_per_batch(image_path, df, H=320, W=320):
    sample_data = []
    for idx, img in enumerate(df.sample(100)["Image"].values):
        # path = image_dir + img
        sample_data.append(
            np.array(image.load_img(image_path, target_size=(H, W))))

    mean = np.mean(sample_data[0])
    std = np.std(sample_data[0])
    return mean, std


def load_image(img, image_dir, df, preprocess=True, H=320, W=320):
    """Load and preprocess image."""
    img_path = image_dir + img
    mean, std = get_mean_std_per_batch(img_path, df, H=H, W=W)
    x = image.load_img(img_path, target_size=(H, W))
    if preprocess:
        x -= mean
        x /= std
        x = np.expand_dims(x, axis=0)
    return x




def grad_cam(input_model, image, cls, layer_name=None, H=320, W=320):
    """
    Compute Grad-CAM heatmap for a specific class.
    If layer_name is not provided, it will use the last convolutional layer.
    """
    # Automatically determine the last convolutional layer if not provided
    if layer_name is None:
        for layer in reversed(input_model.layers):
            if 'conv' in layer.name and 'Conv' in str(layer.__class__):
                layer_name = layer.name
                break
        if layer_name is None:
            raise ValueError("No convolutional layer found in the model.")
    
    # Build a model that maps input image to activations of the specified layer and output predictions
    grad_model = tf.keras.models.Model(
        inputs=input_model.input,
        outputs=[input_model.get_layer(layer_name).output, input_model.output]
    )

    with tf.GradientTape() as tape:
        conv_outputs, predictions = grad_model(image)
        loss = predictions[:, cls]

    # Compute gradients of the loss w.r.t. the layer outputs
    grads = tape.gradient(loss, conv_outputs)

    # Pool the gradients over spatial dimensions
    guided_grads = tf.reduce_mean(grads, axis=(0, 1, 2))

    # Generate the Grad-CAM heatmap
    conv_outputs = conv_outputs[0]  # Remove batch dimension
    heatmap = tf.reduce_sum(tf.multiply(guided_grads, conv_outputs), axis=-1)

    # Normalize the heatmap
    heatmap = np.maximum(heatmap, 0)
    if np.max(heatmap) > 0:
        heatmap /= np.max(heatmap)

    # Resize heatmap to input image size
    heatmap = cv2.resize(heatmap, (W, H))

    return heatmap



def compute_gradcam(model, img, image_dir, df, labels, selected_labels, layer_name=None):
    preprocessed_input = load_image(img, image_dir, df)
    predictions = model.predict(preprocessed_input)

    # Create a dictionary of probabilities for desired labels
    filtered_predictions = {label: predictions[0][labels.index(label)] for label in selected_labels}
    
    # Sort the dictionary by probabilities in descending order
    sorted_predictions = dict(sorted(filtered_predictions.items(), key=lambda item: item[1], reverse=True))
    
    # Select the label with the highest probability
    highest_label = next(iter(sorted_predictions))
    highest_prob = sorted_predictions[highest_label]

    print(f"Generating Grad-CAM for the highest probability label: {highest_label} (p={highest_prob:.3f})")

    # Generate Grad-CAM for the highest probability label using the specified layer
    gradcam = grad_cam(model, preprocessed_input, labels.index(highest_label), layer_name=layer_name)
    
    # Display the original image and the Grad-CAM heatmap
    plt.figure(figsize=(10, 5))
    plt.subplot(121)
    plt.title("Original")
    plt.axis('off')
    plt.imshow(load_image(img, image_dir, df, preprocess=False), cmap='gray')
    
    plt.subplot(122)
    plt.title(f"{highest_label}: Confidence={highest_prob*100:.1f}%")
    plt.axis('off')
    plt.imshow(load_image(img, image_dir, df, preprocess=False), cmap='gray')
    plt.imshow(gradcam, cmap='jet', alpha=0.5)
    plt.show()






def get_roc_curve(labels, predicted_vals, generator):
    auc_roc_vals = []
    for i in range(len(labels)):
        try:
            gt = generator.labels[:, i]
            pred = predicted_vals[:, i]
            auc_roc = roc_auc_score(gt, pred)
            auc_roc_vals.append(auc_roc)
            fpr_rf, tpr_rf, _ = roc_curve(gt, pred)
            plt.figure(1, figsize=(10, 10))
            plt.plot([0, 1], [0, 1], 'k--')
            plt.plot(fpr_rf, tpr_rf,
                     label=labels[i] + " (" + str(round(auc_roc, 3)) + ")")
            plt.xlabel('False positive rate')
            plt.ylabel('True positive rate')
            plt.title('ROC curve')
            plt.legend(loc='best')
        except:
            print(
                f"Error in generating ROC curve for {labels[i]}. "
                f"Dataset lacks enough examples."
            )
    plt.show()
    return auc_roc_vals


def process_sender_image(image_path, df, model, labels, threshold):
    try:
        # Preprocess the image
        preprocessed_image = load_image(image_path, "", df)

        # Predict probabilities
        probabilities = model.predict(preprocessed_image)[0]

        # Create a dictionary of all predictions
        predictions_dict = {
            label: (probabilities[i] if probabilities[i] >= threshold else 0)
            for i, label in enumerate(labels)
        }

        return predictions_dict
    except Exception as e:
        return f"Error: {str(e)}"




# Function to extract texture features: contrast and correlation
def extract_texture_features(image_path):
    # Read the image
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    
    # Resize image to ensure consistent shape
    image = cv2.resize(image, (256, 256))
    
    # Compute GLCM (Grey Level Co-occurrence Matrix)
    glcm = greycomatrix(image, [1], [0], symmetric=True, normed=True)
    
    # Extract contrast and correlation from GLCM
    contrast = greycoprops(glcm, 'contrast')[0, 0]
    correlation = greycoprops(glcm, 'correlation')[0, 0]
    
    return contrast, correlation

# Function to classify based on texture features
def classify_image(contrast, correlation):
    # Set thresholds based on observed values
    if contrast > 20 and correlation > 0.98:
        return 'X-ray'
    else:
        return 'Normal'

# Test a single image and return classification
def val_image(image_path):
    # Extract texture features
    contrast, correlation = extract_texture_features(image_path)
    
    # Classify the image and return only the prediction
    return classify_image(contrast, correlation)