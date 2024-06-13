% Read the image
originalImage = imread('DI_GT1_GR1_LT_D35_CC.jpg');

% Convert to double precision
originalImage = im2double(originalImage);

% Define the illuminant color (e.g., D65 illuminant)
illuminantColor = [0.9505, 1.0, 1.0888];

% Von Kries chromatic adaptation
correctedImage(:,:,1) = originalImage(:,:,1) ./ 0.9505;
correctedImage(:,:,2)= originalImage(:,:,2) ./ 1.0;
correctedImage(:,:,3)= originalImage(:,:,3) ./ 1.0888;

% Clip values to the valid range [0, 1]
correctedImage = max(0, min(correctedImage, 1));

% Display the results
imshowpair(originalImage, correctedImage, 'montage');
title('Original Image vs Corrected Image - Von Kries Hypothesis');


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