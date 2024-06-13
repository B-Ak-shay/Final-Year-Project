% Define folder paths
originalFolderPath = 'E:\PROTON\2023-24\5 - Color Cast Correction\MBU\Code_ML\ColorCastDataset\OriginalImages';
colorCorrectedFolderPath = 'E:\PROTON\2023-24\5 - Color Cast Correction\MBU\Code_ML\ColorCastDataset\CorrectedImages';

% Load original images
originalFiles = dir(fullfile(originalFolderPath, '*.jpg')); % Change file extension if necessary
numOriginalImages = length(originalFiles);
originalImages = cell(1, numOriginalImages);

for i = 1:numOriginalImages
    originalImages{i} = imread(fullfile(originalFolderPath, originalFiles(i).name));
end

% Load color-corrected images
colorCorrectedFiles = dir(fullfile(colorCorrectedFolderPath, '*.jpg')); % Change file extension if necessary
numColorCorrectedImages = length(colorCorrectedFiles);
colorCorrectedImages = cell(1, numColorCorrectedImages);

for i = 1:numColorCorrectedImages
    colorCorrectedImages{i} = imread(fullfile(colorCorrectedFolderPath, colorCorrectedFiles(i).name));
end

% Example: Resize images to a common size
desiredSize = [256, 256]; % Define desired size
for i = 1:numOriginalImages
    originalImagesRGB{i} = imresize(originalImages{i}, desiredSize);
end

for i = 1:numColorCorrectedImages
    colorCorrectedImagesRGB{i} = imresize(colorCorrectedImages{i}, desiredSize);
end

% Example: Convert images to grayscale
for i = 1:numOriginalImages
    originalImages{i} = rgb2gray(originalImagesRGB{i});
end

for i = 1:numColorCorrectedImages
    colorCorrectedImages{i} = rgb2gray(colorCorrectedImagesRGB{i});
end

% Define the number of bins for the histogram
numBins = 256; % You can adjust this value based on your preference

% Initialize arrays to store features
numFeatures = numBins * 3; % Assuming we calculate histograms for all RGB channels
originalFeatures = zeros(numOriginalImages, numFeatures);
colorCorrectedFeatures = zeros(numColorCorrectedImages, numFeatures);

% Extract color histograms for original images
for i = 1:numOriginalImages
    % Calculate histograms for each channel
    [R, ~] = imhist(originalImagesRGB{i}(:, :, 1), numBins);
    [G, ~] = imhist(originalImagesRGB{i}(:, :, 2), numBins);
    [B, ~] = imhist(originalImagesRGB{i}(:, :, 3), numBins);
    
    % Concatenate histograms into a single feature vector
    originalFeatures(i, :) = [R; G; B]';
end

% Extract color histograms for color-corrected images
for i = 1:numColorCorrectedImages
    % Calculate histograms for each channel
    [R, ~] = imhist(colorCorrectedImagesRGB{i}(:, :, 1), numBins);
    [G, ~] = imhist(colorCorrectedImagesRGB{i}(:, :, 2), numBins);
    [B, ~] = imhist(colorCorrectedImagesRGB{i}(:, :, 3), numBins);
    
    % Concatenate histograms into a single feature vector
    colorCorrectedFeatures(i, :) = [R; G; B]';
end

% Normalize features (optional)
originalFeatures = normalize(originalFeatures);
colorCorrectedFeatures = normalize(colorCorrectedFeatures);

% Set the percentage of data for training
trainPercentage = 0.8; % 80% for training, 20% for testing

% Create indices for train and test sets
numSamples = size(originalFeatures, 1);
cv = cvpartition(numSamples, 'HoldOut', 1 - trainPercentage);

% Get indices for training and testing sets
trainIdx = cv.training;
testIdx = cv.test;

% Split the features and labels into train and test sets
X_train = originalFeatures(trainIdx, :);
y_train = colorCorrectedFeatures(trainIdx, :);
y_train = fillNaNsWithZeros(y_train);

X_test = originalFeatures(testIdx, :);
y_test = colorCorrectedFeatures(testIdx, :);
y_test = fillNaNsWithZeros(y_test);
% Define the ratio for splitting the data
trainRatio = 0.8;
testRatio = 0.2;

% Split the original features and color-corrected features into training and testing sets
numSamples = size(originalFeatures, 1);
numTrainSamples = round(trainRatio * numSamples);
numTestSamples = numSamples - numTrainSamples;

% Randomly select samples for training and testing
trainIndices = randperm(numSamples, numTrainSamples);
testIndices = setdiff(1:numSamples, trainIndices);

% Create training and testing sets
trainOriginalFeatures = originalFeatures(trainIndices, :);
trainColorCorrectedFeatures = colorCorrectedFeatures(trainIndices, :);
trainColorCorrectedFeatures = fillNaNsWithZeros(trainColorCorrectedFeatures);

testOriginalFeatures = originalFeatures(testIndices, :);
testColorCorrectedFeatures = colorCorrectedFeatures(testIndices, :);
testColorCorrectedFeatures = fillNaNsWithZeros(testColorCorrectedFeatures);

% Replace NaN values with mean of the respective column for columns 13 to end
% for i = 1:6
%     for j=13:768
%         trainColorCorrectedFeatures(i,j)=mean(trainColorCorrectedFeatures(i,1:12));
%         testColorCorrectedFeatures(i,j)=mean(testColorCorrectedFeatures(i,1:12));
%     end
% end


% for i = 1:6
%     for j=1:768
%         trainColorCorrectedFeaturesRes(i,j)=trainColorCorrectedFeatures(i,j);
%         trainOriginalFeaturesRes(i,j)=trainOriginalFeatures(i,j);
%     end
% end



% Define the number of trees in the forest
numTrees = 100;


% Initialize arrays to store predicted color corrected features and MSE
predictedColorCorrectedFeatures = zeros(size(originalFeatures));
mse = zeros(size(originalFeatures, 1), 1);

% Define the number of folds for cross-validation
numFolds = 5;

% Initialize array to store MSE for each fold
mse_per_fold = zeros(numFolds, 1);

% Perform k-fold cross-validation
cv = cvpartition(size(originalFeatures, 1), 'KFold', numFolds);
for fold = 1:numFolds
    % Get indices for training and testing sets
    trainIdx = cv.training(fold);
    testIdx = cv.test(fold);
    
    % Split the data into training and testing sets
    X_train = originalFeatures(trainIdx, :);
    y_train = colorCorrectedFeatures(trainIdx, :);
    
    X_test = originalFeatures(testIdx, :);
    y_test = colorCorrectedFeatures(testIdx, :);
    
    % Train the SVM model
    svmModel = fitrsvm(X_train, y_train, 'Standardize', true);
    
    % Predict color corrected features for the test set
    predictedColorCorrectedFeatures = predict(svmModel, X_test);
    
    % Calculate Mean Squared Error (MSE) for the current fold
    mse_per_fold(fold) = immse(predictedColorCorrectedFeatures, y_test);
end

% Calculate average MSE across all folds
avg_mse = mean(mse_per_fold);
fprintf('Average Mean Squared Error (MSE) using %d-fold cross-validation: %.4f\n', numFolds, avg_mse);
