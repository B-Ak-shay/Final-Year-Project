clc;
clear all;
close all;
% Read the image
originalImage = imread('DI_GT1_GR1_LT_D35_CC.jpg');

% Convert to double precision
originalImage = im2double(originalImage);

% Define the gamma values for each color channel
gammaR = 0.8; % Adjust as needed
gammaG = 2.2; % Adjust as needed
gammaB = 2.2; % Adjust as needed

% Apply gamma correction to each color channel
correctedImage(:,:,1) = originalImage(:,:,1) .^ gammaR;
correctedImage(:,:,2) = originalImage(:,:,2) .^ gammaG;
correctedImage(:,:,3) = originalImage(:,:,3) .^ gammaB;

% Clip values to the valid range [0, 1]
correctedImage = max(0, min(correctedImage, 1));

% Display the results
% imshowpair(originalImage, correctedImage, 'montage');
imshow(correctedImage);
title(['Original Image vs Corrected Image - Gamma Correction (\gamma_R = ' num2str(gammaR) ', \gamma_G = ' num2str(gammaG) ', \gamma_B = ' num2str(gammaB) ')']);

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