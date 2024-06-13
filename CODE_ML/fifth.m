clc;
clear all;
% Load images
originalFolderPath = 'ColorCastDataset/OriginalImages/';
correctedFolderPath = 'ColorCastDataset/CorrectedImages/';

originalFiles = dir(fullfile(originalFolderPath, '*.jpg'));
correctedFiles = dir(fullfile(correctedFolderPath, '*.jpg'));

% Initialize arrays to store RGB values
originalRGB = [];
correctedRGB = [];

% Read original and corrected images and store RGB values
for i = 1:numel(originalFiles)
    % Read original image
    originalImg = imread(fullfile(originalFolderPath, originalFiles(i).name));
    originalRGB = [originalRGB; reshape(double(originalImg),[],3)]; % Convert to double

    % Read corrected image
    correctedImg = imread(fullfile(correctedFolderPath, correctedFiles(i).name));
    correctedRGB = [correctedRGB; reshape(double(correctedImg),[],3)]; % Convert to double
end

% Perform linear regression
coefficients = pinv(originalRGB) * correctedRGB;


% Load a test image
testImg = imread('test_image.jpg');
testImg1 = testImg; 
% Apply color cast correction to the test image
[h, w, ~] = size(testImg);
testImg = reshape(double(testImg),[],3); % Convert to double
correctedTestImg = uint8(testImg * coefficients);
correctedTestImg = reshape(correctedTestImg, [h, w, 3]);

% Display the original and corrected test images
subplot(1,2,1), imshow(uint8(testImg1)), title('Original Test Image');
subplot(1,2,2), imshow(correctedTestImg), title('Color Cast Corrected Image');
