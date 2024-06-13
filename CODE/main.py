import numpy as np
import cv2
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

def load_images_with_cast(num_images, folder_path):
    images_with_cast = []
    for i in range(1, num_images + 1):
        image = cv2.imread(f'E:/PROTON/2023-24/5 - Color Cast Correction/Code/Images_with_cast/image_{i}.jpg')
        images_with_cast.append(image)
    return images_with_cast

def load_corrected_images(num_images, folder_path):
    images_corrected = []
    for i in range(1, num_images + 1):
        image = cv2.imread(f'E:/PROTON/2023-24/5 - Color Cast Correction/Code/Corrected/image_{i}.jpg')
        images_corrected.append(image)
    return images_corrected

def extract_features(images):
    features = []
    for image in images:
        mean_rgb = np.mean(image, axis=(0, 1))
        features.append(mean_rgb)
    return np.array(features)

def main():
    num_images = 10  # Update with the actual number of images
    folder_path = 'E:/PROTON/2023-24/5 - Color Cast Correction/Code'

    images_with_cast = load_images_with_cast(num_images, folder_path)
    images_corrected = load_corrected_images(num_images, folder_path)

    features = extract_features(images_with_cast)
    labels = extract_features(images_corrected)

    model = LinearRegression()
    model.fit(features, labels)

    # Optionally, split dataset into training and validation sets for evaluation
    validation_features = features[:5]  # Example: First 5 samples for validation
    validation_labels = labels[:5]  # Example: First 5 samples for validation

    predictions = model.predict(validation_features)
    mse = mean_squared_error(validation_labels, predictions)
    print(f'Mean Squared Error: {mse}')

    # Deploy the model on a new image
    new_image_path = 'E:/PROTON/2023-24/5 - Color Cast Correction/Code/DI_GT1_GR1_LT_D5_CC.jpg'
    new_image = cv2.imread(new_image_path)
    new_features = np.mean(new_image, axis=(0, 1)).reshape(1, -1)
    predicted_labels = model.predict(new_features)
    corrected_image = np.clip(predicted_labels, 0, 255).astype(np.uint8)

    cv2.imshow('Corrected Image', corrected_image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
