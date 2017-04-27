function [histo] = createHistogram(img)
close all
histo_len = max(img(:))-min(img(:))+1;
histo = zeros(1, histo_len);    
y = min(img(:)); % need to subrtact the minimum when we finally calculate the threshold value
    for x = 1:histo_len
        histo(x) = length(find(img==y));
        y=y+1;
    end    
figure

values = min(img(:)):1:max(img(:));
plot(values, histo)
title('Actual histogram')

figure
plot(histo)
title('Working histogram')

% MATLAB's histogram for comparison
% figure
% histogram(img,3000)
% title('matlab_histo')
 
end
 
