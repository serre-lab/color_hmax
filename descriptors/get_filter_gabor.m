function [gfilters,cfilters] = get_filter_gabor(size_f,rot, div,numChannel,phase)
% modified from Thomas Serre's Gabor filters used in standard HMAX model
% (Serre et al.2007)
% Author: Jun Zhang & Youssef Barhomi


%%
if nargin < 4
    numPhase = 1;
    numChannel = 8;
elseif nargin < 5
    phase = 0;
end


lambda = size_f*2/div; %wavelength
sigma  = lambda.*0.8; %effective bandwidth
G = 0.3; %spatial aspect ratio



gfilters =  GenerateGabor(size_f,rot, G, lambda, sigma, 'norm', phase);

% seperate gabor to positive and negative ones
filter1 = GenerateGabor(size_f, rot, G, lambda, sigma, 'positive', phase);
filter2 = GenerateGabor(size_f, rot, G, lambda, sigma, 'negative', phase);

numPhase = length(phase);
filter = cell(numPhase,1);
for pp = 1:numPhase
    filter{pp}(:,:,1,:) = abs(filter1{pp});
    filter{pp}(:,:,2,:) = abs(filter2{pp});
end



% weights for opponent color channels
if numChannel == 8
    weights = [1/sqrt(2),-1/sqrt(2),0; 2/sqrt(6),-1/sqrt(6),-1/sqrt(6); 1/sqrt(6),1/sqrt(6),-2/sqrt(6); 1/sqrt(3),1/sqrt(3),1/sqrt(3)]';
else if numChannel == 6
        weights = [1/sqrt(2),-1/sqrt(2),0; 2/sqrt(6),-1/sqrt(6),-1/sqrt(6); 1/sqrt(6),1/sqrt(6),-2/sqrt(6)]';
    end
end
weights = [weights , -weights];



% spatio-chromatic opponent filters
cfilters = cell(numPhase,1);

for pp = 1:numPhase

    for ii=1:3
        for jj=1:numChannel
            if weights(ii,jj) >= 0
                hh = 1;
            elseif weights(ii,jj) < 0
                hh = 2;
            end
            
            cfilters{pp}(:,:,ii,jj,:) =  weights(ii,jj) * filter{pp}(:,:,hh,:);
        end 
    end
    
end



filter_all = cell(numPhase,1);
for pp = 1:numPhase
    filter_all{pp} = reshape(cfilters{pp}, size_f, size_f, 3, numChannel*length(rot));

    for i=1:3
        for j=1:numChannel*length(rot)
            nn = norm(filter_all{pp}(:,:,i,j),2);
            if nn ~= 0
                filter_all{pp}(:,:,i,j) = filter_all{pp}(:,:,i,j)/nn;
            end
        end
    end
    
    cfilters{pp} = reshape(filter_all{pp},size_f,size_f,3,numChannel,length(rot));  
end




function fVals = GenerateGabor(rfCount, rot, aspectRatio, lambda, sigma, gabor_sign, phase)                                              

fCount = length(rot);
pCount = length(phase);
fVals = cell(pCount,1);
points = (1 : rfCount) - ((1 + rfCount) / 2);

for p = 1:pCount
%     phase =  (p - 1) / 2 * pi;
    alpha = phase(p) * pi / 180;
    
    for f = 1 : fCount
%         theta = (f - 1) / fCount * pi;
        theta = rot(f) * pi / 180;

        for j = 1 : rfCount
            for i = 1 : rfCount
                x = points(j) * cos(theta) - points(i) * sin(theta);
                y = points(j) * sin(theta) + points(i) * cos(theta);

                if sqrt(x * x + y * y) <= rfCount / 2
                    e = exp(-(x * x + aspectRatio * aspectRatio * y * y) / (2 * sigma * sigma));
                    e = e * cos(2 * pi * x / lambda + alpha);
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


