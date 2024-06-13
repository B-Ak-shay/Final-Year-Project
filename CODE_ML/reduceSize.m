% Load images
originalFolderPath = 'ColorCastDataset/OriginalImages/';
correctedFolderPath = 'ColorCastDataset/CorrectedImages/';

originalFiles = dir(fullfile(originalFolderPath, '*.jpg'));
correctedFiles = dir(fullfile(correctedFolderPath, '*.jpg'));

% Resize resolution
newResolution = [300, 300]; % New resolution size

% Process images
for i = 1:numel(originalFiles)
    % Read original image
    originalImg = imread(fullfile(originalFolderPath, originalFiles(i).name));
    originalImgResized = imresize(originalImg, newResolution);
    imwrite(originalImgResized, fullfile(originalFolderPath, ['resized_' originalFiles(i).name]));

    % Read corrected image
    correctedImg = imread(fullfile(correctedFolderPath, correctedFiles(i).name));
    correctedImgResized = imresize(correctedImg, newResolution);
    imwrite(correctedImgResized, fullfile(correctedFolderPath, ['resized_' correctedFiles(i).name]));
end
