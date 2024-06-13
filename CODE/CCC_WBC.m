% Read the image
originalImage = imread('DI_GT1_GR1_LT_D35_CC.jpg');

% Convert to double precision
originalImage = im2double(originalImage);

% Calculate the average color of the image
averageColor = mean(originalImage, [1, 2]);

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
title('Original Image vs Corrected Image - White Balance Correction');


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