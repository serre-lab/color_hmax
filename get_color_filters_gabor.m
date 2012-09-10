function [gfilters,subfilters, cfilters] = get_filters_color_gabor(size_f, rot, div,numChannel,pCount)

% Gradient computation
% Here, we take Gabor filters as an example because it is biologically 
% plausible. Any gradient operators could be used, such as Gaussian 
% derivatives
% modified from Thomas Serre's Gabor filters used in standard Hmax
% by Jun Zhang & Youssef Barhomi



lambda = size_f*2/div;%wavelength
sigma  = lambda.*0.8;%effective bandwidth
G      = 0.3; %spatial aspect ratio

gfilters = GenerateGabor(size_f, rot, G, lambda, sigma, 'nornmal',pCount);

%seperate to pos and neg parts
filter1 = GenerateGabor(size_f, rot, G, lambda, sigma, 'positive',pCount);
filter2 = GenerateGabor(size_f, rot, G, lambda, sigma, 'negative',pCount);

subfilters = {};
for p = 1:pCount
    for j=1:length(rot)
        subfilters{p}(:,:,1,j) = abs(filter1{p}(:,:,j));
        subfilters{p}(:,:,2,j) = abs(filter2{p}(:,:,j));
    end
end

if numChannel == 8
    weight = [1/sqrt(2),-1/sqrt(2),0; 2/sqrt(6),-1/sqrt(6),-1/sqrt(6); 1/sqrt(6),1/sqrt(6),-2/sqrt(6); 1/sqrt(3),1/sqrt(3),1/sqrt(3)]';
else if numChannel == 6;
        weight = [1/sqrt(2),-1/sqrt(2),0; 2/sqrt(6),-1/sqrt(6),-1/sqrt(6); 1/sqrt(6),1/sqrt(6),-2/sqrt(6)]';
    end
end
weight = [weight , -weight];


cfilters = {};
for p = 1:pCount
    for i=1:3
        for j=1:numChannel
            
            if weight(i,j) > 0
            %take the positive gabor
            hh = 1;
            elseif weight(i,j) < 0
            %take the negative gabor
            hh = 2;
            elseif weight(i,j) == 0
                hh = 1;
            end  
            cfilters{p}(:,:,i,j ,:) =  weight(i,j) * subfilters{p}(:,:,hh,:);

            for k=1:length(rot)
                nn = norm(filters{p}(:,:,i,j,k),2);
                if nn ~= 0
                    cfilters{p}(:,:,i,j,k) = cfilters{p}(:,:,i,j,k)/nn;
                end
            end
                       
        end
    end
end



function fVals = GenerateGabor(rfCount, rot, aspectRatio, lambda, sigma, gabor_sign,pCount)                                              

fVals = {};
points = (1 : rfCount) - ((1 + rfCount) / 2);

for p = 1:pCount
    phase =  (p - 1) / 2 * pi;  
    for f = 1 : length(rot)
        theta = rot(f) / 180 * pi;%0,45,90,135 

        for j = 1 : rfCount
            for i = 1 : rfCount
                x = points(j) * cos(theta) - points(i) * sin(theta);
                y = points(j) * sin(theta) + points(i) * cos(theta);
       
                if sqrt(x * x + y * y) <= rfCount / 2
                    e = exp(-(x * x + aspectRatio * aspectRatio * y * y) / (2 * sigma * sigma));
                    e = e * cos(2 * pi * x / lambda + phase);
                else
                    e = 0;
                end
                fVals{p}(i, j, f) = e;
            end
        end

        a = fVals{p}(:,:,f);
        a = a - mean(a(:)); 
        a = a / std(a(:));
        fVals{p}(:,:,f) = a;      
    end

    if strcmp(gabor_sign, 'positive')
        fVals{p}(fVals{p}<0) = 0;
    elseif  strcmp(gabor_sign, 'negative')
        fVals{p}(fVals{p}>0) = 0;
    end   
    
end
    
 

return;

