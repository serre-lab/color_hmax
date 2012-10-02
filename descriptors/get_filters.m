function filter = get_filters(size_f, rot, div,phase)
% modified from Thomas Serre's Gabor filters used in standard HMAX model
% (Serre et al.2007)


%%
if nargin < 4
    phase = 0;
end



lambda = size_f*2/div;%wavelength
sigma  = lambda.*0.8;%effective bandwidth
G      = 0.3;


filter = GenerateGabor(size_f,rot, G,  lambda, sigma, 'normal',phase);
% gabor sign: 'normal'-basic gabor; 'positive'/'negative':
% positive/negative units of gabor


function fVals = GenerateGabor(rfCount, rot, aspectRatio, lambda, sigma, gabor_sign,phase)

pCount = length(phase);
fVals = cell(pCount,1);
fCount = length(rot);
points = (1 : rfCount) - ((1 + rfCount) / 2);

for p = 1:pCount
    
    %     phase =  (p - 1) / 2 * pi;%phases: 0,90,180,270
    alpha = phase(p) * pi / 180;
    
    for f = 1 : fCount
        
        theta = rot(f) * pi / 180;%orients: 0,45,90,135 degrees
        
        
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
        
        %to make gabor mean 0, std 1
        a = fVals{p}(:,:,f);
        a = a - mean(a(:));
        a = a / std(a(:));
        fVals{p}(:,:,f) = a;
    end
    
    
    if strcmp(gabor_sign, 'positive')
        fVals(fVals<0) = 0;
    elseif  strcmp(gabor_sign, 'negative')
        fVals(fVals>0) = 0;
    end
    
end


return;
