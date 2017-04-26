function [histo] = createHistogram(img)
close all
histo_len = max(img(:))-min(img(:));
histo = zeros(1, histo_len);    
y = min(img(:));
    for x = 1:histo_len
        histo(x) = length(find(img==y));
        y=y+1;
    end    
figure
plot(histo)
title('my_histo')

figure
histogram(img)
title('matlab_histo')

figure 
imshow(img, [])
title('working img')
end

