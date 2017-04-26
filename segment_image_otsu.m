function [ segmented_mask, level, stats] = segment_image_otsu( img, otsu_steps, pixel_size, slice_thickness)
%SEGMENT IMAGE OTSU Segement 2D image usig two different types of
%thresholding
%   Inputs: 
%       img ? img to be segmented
%       otsu_steps: type of segmentation ? 1: conventional otse, 2: two-step otsu
%   Outputs: 
%       segmented_mask: bool matrix with same size as image to be segmented with value=1 for object pixels and value = 0 for background
%   	level: threshold obtained with auto segmentation method ( conventional Ostus)
%       stats: structure with the fields: 
%           voume_pix: size of pixels in segmented mask
%           volume_mm3: size in mm^3 of the segmented mask 
%           mean_gray_pix: average of gray value per pixel in segmented object

imgSingle = single(img);



end

function [histo] = createHistogram(img)
histo_len = max(img(:))-min(img(:));
histo = zeros(1, histo_len);    
    for x = 0:histo_len
        histo(x) =length(find(image==x));
    end    
end
