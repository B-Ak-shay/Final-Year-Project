function feature = extractFeature(image)
    % Assuming image is an RGB image
    
    % Convert the image to LAB color space
    labImage = rgb2lab(image);
    
    % Extract features from LAB color space
    % For example, you can compute statistics of the LAB channels
    L = labImage(:,:,1);
    A = labImage(:,:,2);
    B = labImage(:,:,3);
    
    % Compute mean, std, median, etc. of each channel
    L_mean = mean(L(:));
    L_std = std(L(:));
    A_mean = mean(A(:));
    A_std = std(A(:));
    B_mean = mean(B(:));
    B_std = std(B(:));
    
    % Concatenate features into a feature vector
    feature = [L_mean, L_std, A_mean, A_std, B_mean, B_std];
end
