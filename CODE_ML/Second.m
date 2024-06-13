originalImagesDir = 'E:/PROTON/2023-24/5 - Color Cast Correction/MBU/Code_ML/ColorCastDataset/OriginalImages/';
correctedImagesDir = 'E:/PROTON/2023-24/5 - Color Cast Correction/MBU/Code_ML/ColorCastDataset/CorrectedImages/';

originalFiles = dir(fullfile(originalImagesDir, '*.jpg'));
correctedFiles = dir(fullfile(correctedImagesDir, '*.jpg'));

numImages = length(originalFiles);

imageSize = [256, 256]; % Or any other desired size

% Example for computing RGB histograms
image = imread(fullfile(originalImagesDir, originalFiles(1).name));
histogram = imhist(image);

% Example: Training a simple linear regression model
X = []; % Features
Y = []; % Corrected images

for i = 1:numImages
    % Load original and corrected images
   % Load original and corrected images
originalImage = imread(fullfile(originalImagesDir, originalFiles(i).name));
correctedImage = imread(fullfile(correctedImagesDir, correctedFiles(i).name));

% Resize corrected image to match the size of the original image
correctedImage = imresize(correctedImage, [size(originalImage, 1), size(originalImage, 2)]);

% Concatenate images vertically
Y = [Y; correctedImage'];

end

% Train linear regression model
model = fitrlinear(X, Y);
