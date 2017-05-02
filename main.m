close all 
img_id = fopen('CT_Slice_noise.raw','r','l');
img = fread(img_id, [320,440], 'int16', 0, 'l' );
d0 = 0.3;
%filt_img = freq_filter_image(img,d0);
[ segmented_mask, level, stats] = segment_image_otsu( img, 2, [0.74 0.74], 1.5);

% [x, y] = size(img)
% lengthOfHisto= x*y;
% levelTest = graythresh(greyImg).* lengthOfHisto
