function [ filt_img ] = freq_filter_image( img, D0 )
%FREQ_FILTER_IMAGE 
%   Filter noisy image using a butterworth filter
%   Inputs: img: image to be filtered, D0: threshold
%   Ouputs: filt_img : filtered image

% Create the fourier transform of the image
imgDim = size(img);
fimg_Original = fft2(single(img));
fimg = fftshift(fimg_Original);

% Create the mask using the formula
H = zeros(imgDim(1),imgDim(2));

% find the centre of the fourier transform 
% (Note we could also use: [centreX, centreY] =
% [floor(imgY/2)+1,floor(imgX/2)+1]
meanValue = mean(img(:));
[centreX, centreY] = find(fimg == meanValue*(320*440));
maxDistance = sqrt(centreX^2 + centreY^2);

% use formula to fill in H for each pixel, where D is the normailized
% distance to centre
for x = 1:imgDim(1)
    for y = 1:imgDim(2)
        H(x,y) = 1/(sqrt(1 + ((sqrt((x-centreX)^2 + (y-centreY)^2)./maxDistance)^2)/D0)^(2*2));
    end 
end 

% mulitpy img and mask in frequency domain
filt_img_freq = fimg .* H;

% shift the result back (since we shifted original fourier transform)
% Then take the inverse fourier transform, take only the real values
filt_img = real(ifft2(ifftshift(filt_img_freq)));

% display image
figure
imshow(filt_img,[]);
titleString = sprintf('Butterworth Filtered Image with Cutoff Frequency: %d',D0);
title(titleString)
end

