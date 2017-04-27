function [ filt_img ] = freq_filter_image( img, D0 )
%FREQ_FILTER_IMAGE 
%   Filter noisy image using a butterworth filter
%   Inputs: img: image to be filtered, D0: threshold
%   Ouputs: filt_img : filtered image

% Create the fourier transform of the image
imgDim = size(img);
fimg_Original = fft2(double(img));
fimg = fftshift(fimg_Original);
%fimg_shifted = abs(fftshift(fimg));
% Create the mask using the formula
H = zeros(imgDim(1),imgDim(2));
% Go through each pixel and get H value
% Note: should we be using fimg to create this H?\
% D is the normalized distance to centre
 meanValue = mean(img(:));
[centreX, centreY] = find(fimg == meanValue*(320*440));
maxDistance = sqrt(centreX^2 + centreY^2);
% this will always be imgY/2 + 1 for even 
for x = 1:imgDim(1)
    for y = 1:imgDim(2)
        H(x,y) = 1/(sqrt(1 + ((sqrt((x-centreX)^2 + (y-centreY)^2)./maxDistance)^2)/0.1)^(2*2));
    end 
end 

% mulitpy img and mask in frequency domain
filt_img_freq = fimg .* H;
filt_img = real(ifft2(ifftshift(filt_img_freq)));
figure
imshow(filt_img,[]);
end

