% Path to the dataset folder
datasetPath = 'E:\PROTON\2023-24\5 - Color Cast Correction\MBU\Code_ML\ColorCastDataset';

% Load original and corrected images
originalFolder = fullfile(datasetPath, 'OriginalImages');
correctedFolder = fullfile(datasetPath, 'CorrectedImages');

% Load original and corrected images
originalImages = imageDatastore(originalFolder);
correctedImages = imageDatastore(correctedFolder);

% Extract features and labels
X = []; % Features
Y = []; % Labels

for i = 1:numel(originalImages.Files)
    % Read original and corrected images
    originalImage = readimage(originalImages, i);
    correctedImage = readimage(correctedImages, i);
    
    % Resize corrected image to match the dimensions of the original image
    resizedCorrectedImage = imresize3(correctedImage, size(originalImage));
    
    % Extract features from original and resized corrected images
    featureOriginal = extractFeature(originalImage);
    featureCorrected = extractFeature(resizedCorrectedImage);
    
    % Append features to X and corrected image features to Y
    X = [X; featureOriginal];
    Y = [Y; featureCorrected];
end

% Train linear regression model
model = fitrlinear(X, Y);

% Define the new image size
newImageSize = [100, 100, 3]; % Change this to the desired size


% Apply the model to original images
for i = 1:numel(originalImages.Files)
    % Read original image
    originalImage = readimage(originalImages, i);
    
    % Resize the original image to the new size
    resizedImage = imresize(originalImage, newImageSize(1:2));
    
    % Predict corrected image features
    predictedFeatures = predict(model, extractFeature(resizedImage));
    
    % Display the sizes for debugging
    disp(['Original image size: ', num2str(newImageSize)]);
    disp(['Predicted features size: ', num2str(size(predictedFeatures))]);
    
    % Check if the predicted features size matches the new image size
    if numel(predictedFeatures) ~= prod(newImageSize)
        error('Predicted features size does not match the new image size.');
    end
    
    % Reshape predicted features to match the size of the new image
    predictedImage = reshape(predictedFeatures, newImageSize);
    
    % Display or save corrected image
    imshowpair(resizedImage, predictedImage, 'montage');
    title('Original Image vs Predicted Corrected Image (Resized)');
end







% Define feature extraction function (e.g., color histogram)
function feature = extractFeature(image)
    % Example: compute RGB color histogram
    [counts, ~] = imhist(image);
    feature = counts(:);
end
