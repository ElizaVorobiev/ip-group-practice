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
 
image = double(img);
sizeim = size(image);
[hist, values] = createHistogram(image);

for step = 1:otsu_steps
    probhist = hist ./ sum(hist);

    bcv2 = zeros(1, length(hist));

    for t = 1:length(hist) 
        weightback = sum(probhist(1:t));    
        weightobj = 1-weightback;

        meanback = (sum(probhist(1:t).* values(1:t))) ./ weightback; %this shoud img value not hist
        meanobj = sum(probhist(t+1:length(hist)) .* values(t+1:length(hist))) ./ weightobj;

        sigmab3 = weightback * weightobj * ((meanback - meanobj)^2);

        bcv2(t) = sigmab3;

    end

    level = find(bcv2 == max(bcv2)) + min(image(:))-1;
    hist = hist(level - min(image(:))+1:length(hist));

end

segmented_mask = zeros(sizeim);
segmented_mask(image > level) = 1;

volume_pix = pixel_size(1) * pixel_size(2) * slice_thickness;
volume_mm3 = size(find(segmented_mask ==1)).* volume_pix;
segmented_img = image(segmented_mask == 1);
mean_gray_pix = mean(segmented_img(:));

stats = [volume_pix, volume_mm3, mean_gray_pix];

% display image to be segmented
figure
imshow(img, [])
title('Image to be segmented')
% display segmented mask 
figure
imshow(segmented_mask)
title('Segmentation Mask')
% display figure with a color image in which you will display the image to be segmented (in grayscale) and the pixels belonging to the object in color. 
% convert image to 0-255 range
% convert to rgb
% if in color mask set the img value to (imgVal,0,0)
grayImg= mat2gray(img); %values of 0 to 1
colorImg = grayImg .* 255; % values of 0-255
rgbImg= cat(3, colorImg, colorImg, colorImg);
% rgbImg(segmented_mask==1) = img, 0, 0;
% if pixel in segmented mask == 1 color it with RGB
% if pixel in segmented mask == 0 leave in grayscale

end