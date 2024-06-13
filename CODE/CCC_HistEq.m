% Read the image
originalImage = imread('DI_GT1_GR1_LT_D35_CC.jpg');

% Convert to double precision
originalImage = im2double(originalImage);

% Calculate the color histograms for each channel
histR = imhist(originalImage(:, :, 1));
histG = imhist(originalImage(:, :, 2));
histB = imhist(originalImage(:, :, 3));

% Find the peak values in each histogram
peakR = find(histR == max(histR));
peakG = find(histG == max(histG));
peakB = find(histB == max(histB));

% Calculate the scaling factors based on the peaks
scaleR = peakG / peakR;
scaleB = peakG / peakB;

% Apply the scaling factors
correctedImage = originalImage;
correctedImage(:, :, 1) = originalImage(:, :, 1) * scaleR;
correctedImage(:, :, 3) = originalImage(:, :, 3) * scaleB;

% Clip values to the valid range [0, 1]
correctedImage = max(0, min(correctedImage, 1));

% Display the results
imshowpair(originalImage, correctedImage, 'montage');
title('Original Image vs Corrected Image - Histogram-Based Method');


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