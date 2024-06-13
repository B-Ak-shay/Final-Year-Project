% Load the pre-trained GoogLeNet model
net = googlenet;

% Load your dataset of images
imageFiles = dir('C:/Users/jpmpw/Desktop/Dataset/Ground Truth Images/*.jpg');
numImages = numel(imageFiles);

% Initialize arrays to store features and labels
features = [];
labels = [];

% Loop through each image in the dataset
for i = 1:numImages
    % Read the image
    img = imread(fullfile(imageFiles(i).folder, imageFiles(i).name));
    
    % Preprocess the image for GoogLeNet
    img = imresize(img, net.Layers(1).InputSize(1:2));
    img = preprocess(net, img);
    
    % Extract features using GoogLeNet
    features_i = activations(net, img, 'pool5');
    features_i = squeeze(mean(mean(features_i, 1), 2))'; % Flatten and take mean
    
    % Append features to the features array
    features = [features; features_i];
    
    % Assign a label to the image based on its color cast level
    % You'll need to define how to determine the color cast level
    label_i = determineColorCastLevel(img);
    
    % Append the label to the labels array
    labels = [labels; label_i];
end

% Save features and labels to .mat files
save('color_features_data.mat', 'features');
save('color_cast_labels.mat', 'labels');
