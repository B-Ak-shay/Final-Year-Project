% Read the image
originalImage = imread('DI_GT1_GR1_LT_D35_CC.jpg');

% Convert to double precision
originalImage = im2double(originalImage);

% Calculate the color saturation of the image
saturation = max(originalImage, [], 3) - min(originalImage, [], 3);

% Define a threshold for low saturation regions
threshold = 0.2;

% Identify low saturation regions (edges)
lowSaturationRegions = saturation < threshold;

% Calculate the average color in low saturation regions for each channel
averageColor = zeros(1, 1, 3);
for channel = 1:3
    channelValues = originalImage(:, :, channel);
    averageColor(channel) = mean(channelValues(lowSaturationRegions));
end

% Calculate scaling factors based on the average color
scaleR = 0.5 / averageColor(1);
scaleG = 0.5 / averageColor(2);
scaleB = 0.5 / averageColor(3);

% Apply the scaling factors
correctedImage = originalImage;
correctedImage(:, :, 1) = originalImage(:, :, 1) * scaleR;
correctedImage(:, :, 2) = originalImage(:, :, 2) * scaleG;
correctedImage(:, :, 3) = originalImage(:, :, 3) * scaleB;

% Clip values to the valid range [0, 1]
correctedImage = max(0, min(correctedImage, 1));

% Display the results
imshowpair(originalImage, correctedImage, 'montage');
title('Original Image vs Corrected Image - Grey Edge Algorithm');



global fm_deg;
[m,n] = size(correctedImage);
j = 1;
param1 = ['ACMO', 'BREN', 'GRAS', 'LAPM','LAPV', 'LAPD', 'WAVV'];
for i=1:4:28
    param = param1(i:i+3);
    fm_deg(j) = fmeasure(correctedImage, param, [1 1 m n]);
    j=j+1;
end
% save fm_deg;