close all 
img_id = fopen('CT_Slice_noise.raw','r','l');
img = fread(img_id, [320,440], 'int16', 0, 'l' );
d0 = 1;
filt_img = freq_filter_image(img,d0);

imshow(img,[])
fimg = fft2(double(img),320,440);
figure
fimg_shifted = abs(fftshift(fimg));
imagesc(fimg_shifted)
figure
imshow(filt_img,[])
title('filtered image function output')
figure
newImg = img - filt_img;
imshow(newImg,[])
title('maybe?')