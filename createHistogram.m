function [histo,values] = createHistogram(img)
    histo_len = max(img(:))-min(img(:))+1;
    histo = zeros(1, histo_len);    
    y = min(img(:)); % need to subrtact the minimum when we finally calculate the threshold value
        for x = 1:histo_len
            histo(x) = length(find(img==y));
            y=y+1;
        end    

    values = min(img(:)):1:max(img(:));
 
end
 