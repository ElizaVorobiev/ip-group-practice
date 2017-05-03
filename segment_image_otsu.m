function [ segmented_mask, level, stats] = segment_image_otsu( img, otsu_steps, pixel_size, slice_thickness)
%SEGMENT IMAGE OTSU Segement 2D image usig two different types of
%thresholding
%   Inputs: 
%       img : img to be segmented
%       otsu_steps: type of segmentation ? 1: conventional otse, 2: two-step otsu
%   Outputs: 
%       segmented_mask: bool matrix with same size as image to be segmented with value=1 for object pixels and value = 0 for background
%       level: threshold obtained with auto segmentation method ( conventional Ostus)
%       stats: structure with the fields: 
%           volume_pix: size of pixels in segmented mask
%           volume_mm3: size in mm^3 of the segmented mask 
%           mean_gray_pix: average of gray value per pixel in segmented object

% convert image to single to ensure all values to one type
image = single(img);
sizeim = size(image);
% get histogram and values for the image
[hist, values] = createHistogram(image);

% if doing conventional otsu find the threshold once, otherwise find
% threshold number of times defined by ostu_steps
for step = 1:otsu_steps
    % calculate the probability of each value using the histogram
    probhist = hist ./ sum(hist);
    % create a placeholder variable for before class variance
    bcv = zeros(1, length(hist));

    for t = 1:length(hist) 
        % Implement formula given in lecture
        weightback = sum(probhist(1:t));    
        weightobj = 1-weightback;

        meanback = (sum(probhist(1:t).* values(1:t))) ./ weightback; 
        meanobj = sum(probhist(t+1:length(hist)) .* values(t+1:length(hist))) ./ weightobj;

        sigmab3 = weightback * weightobj * ((meanback - meanobj)^2);

        bcv(t) = sigmab3;

    end
    
    % calculate the level based on max class variance, add the min value
    % and negative one since we shifted our histogram
    level_position = find(bcv == max(bcv));
    level = level_position + min(values(:))-1; 
    
    % display histogram being used
    figure 
    plot(hist);
    strTitle = sprintf('Histogram for Otsu step %d, threshold position : %d',step,level_position);
    title(strTitle)
    
    % create new histogram and values based on new threshold
    values = values(level_position:length(hist));
    hist = hist(level_position:length(hist));

end

% create segmented mask
segmented_mask = zeros(sizeim);
segmented_mask(image > level) = 1;
segmented_img = image(segmented_mask == 1);

%calculate stats values
volume_pix = pixel_size(1) * pixel_size(2) * slice_thickness;
[sizeX, sizeY] = size(segmented_img);
volume_mm3 = sizeX .* sizeY .* volume_pix;
mean_gray_pix = mean(segmented_img(:));
stats = [volume_pix, volume_mm3, mean_gray_pix];

% display image to be segmented
figure
imshow(img, [])
title('Image to be segmented')

% display segmented mask 
figure
imshow(segmented_mask,[])
title('Segmentation Mask')

% display figure with a color image in which you will display the image to be segmented (in grayscale) and the pixels belonging to the object in color. 
% normalize values so we can display image in grayscale
grayImage = mat2gray(img);
% convert image to RGB
rgbImage = cat(3, grayImage, grayImage, grayImage);
% find areas within the mask
[x, y, v] = find(segmented_mask == 1);
% for each pixel within the mask, set rgb value to red
for z=1:length(v)
    rgbImage(x(z),y(z),:) = cat(3, grayImage(x(z),y(z)), 0, 0);
end
figure
imshow(rgbImage,[]);
title('Original Image with Semgented Object in Red')
end