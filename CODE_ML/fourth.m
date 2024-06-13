% Path to the dataset folder
datasetPath = 'E:\PROTON\2023-24\5 - Color Cast Correction\MBU\Code_ML\ColorCastDataset';

% Load original and corrected images
originalFolder = fullfile(datasetPath, 'OriginalImages');
correctedFolder = fullfile(datasetPath, 'CorrectedImages');

% Load original and corrected images
originalImages = imageDatastore(originalFolder);
correctedImages = imageDatastore(correctedFolder);

% Prompt user to select an image
[file, path] = uigetfile(fullfile(originalFolder, '*.jpg'), 'Select an image');
if isequal(file, 0)
    disp('User canceled the operation.');
    return;
end

% Read the selected image
selectedImage = imread(fullfile(path, file));

% Extract features from the selected image
featureSelected = extractFeature(selectedImage);

% Predict corrected image features using the trained model
featureSelected = featureSelected(:); % Reshape featureSelected into a single column
predictedFeature = predict(model, featureSelected);


% Reshape the predicted feature vector to match the size of the selected image
predictedImage = reshape(predictedFeature, size(selectedImage, 1), size(selectedImage, 2), size(selectedImage, 3));

% Resize the predicted image to match the dimensions of the original image
resizedPredictedImage = imresize(predictedImage, [size(selectedImage, 1), size(selectedImage, 2)]);

% Display the original and corrected images side by side
figure;
montage({selectedImage, resizedPredictedImage}, 'Size', [1, 2]);
title('Original Image vs. Corrected Image');
