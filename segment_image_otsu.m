function [ segmented_mask, level, stats] = segment_image_otsu( img, otsu_steps, pixel_size, slice_thickness)
%SEGMENT IMAGE OTSU Segement 2D image usig two different types of
%thresholding
%   Inputs: 
%       img ? img to be segmented
%       otsu_steps: type of segmentation ? 1: conventional otse, 2: two-step otsu
%   Outputs: 
%       segmented_mask: bool matrix with same size as image to be segmented with value=1 for object pixels and value = 0 for background
%       level: threshold obtained with auto segmentation method ( conventional Ostus)
%       stats: structure with the fields: 
%           voume_pix: size of pixels in segmented mask
%           volume_mm3: size in mm^3 of the segmented mask 
%           mean_gray_pix: average of gray value per pixel in segmented object
 
image = double(img);
sizeim = size(image);
hist = createHistogram(image);
probhist = hist ./ sum(hist);

bcv = zeros(1, length(hist));
% bcv2 = zeros(1, length(hist));
% w1 = probhist(1);

for t = 1:length(hist) %currently including value at index t in threshold. idk if this is right.
    weightback = sum(probhist(1:t));    
    weightobj = 1-weightback;
    
    meanback = sum(probhist(1:t).* hist(1:t));
    meanobj = sum(probhist(t+1:length(hist)) .* hist(t+1:length(hist)));
    
    meanG = weightback*meanback + weightobj*meanobj; %almost the same as meanobj
    meant = sum(probhist(1:t).* hist(1:t)); %same as meanback 
    
    sigmab2 = ((meanG*weightback - meant)^2)/(weightback * weightobj); %i'm not sure if this is the correct formula. the internet says the second one.
    %sigmab3 = weightback * weightobj * ((meanback - meanobj)^2);
    
    bcv(t) = sigmab2;
    bcv2(t) = sigmab3;
    
end

level = find(bcv == max(bcv)) - abs(min(image(:))); %WRONG
%find(bcv2 == max(bcv2))

segmented_mask = zeros(sizeim);
for x = 1:sizeim(1)
    for y = 1:sizeim(2)
        if image(x,y) < level
            segmented_mask(x,y) = 0;
        else
            segmented_mask(x,y) = 1;
        end
    end
end

stats = 

end
