function [fSiz,filters,c1OL,numSimpleFilters] = init_gabor(rot, RF_siz, Div)
% function init_gabor(rot, RF_siz, Div)
% Thomas R. Serre
% Feb. 2003

c1OL             = 2;
numFilterSizes   = length(RF_siz);
numSimpleFilters = length(rot);
numFilters       = numFilterSizes*numSimpleFilters;
fSiz             = zeros(numFilters,1);	
filters          = zeros(max(RF_siz)^2,numFilters);

lambda = RF_siz*2./Div; 
sigma  = lambda.*0.8;
G      = 0.3;   % spatial aspect ratio: 0.23 < gamma < 0.92

for k = 1:numFilterSizes 
    for r = 1:numSimpleFilters 
        theta     = rot(r)*pi/180; 
        filtSize  = RF_siz(k);
        center    = ceil(filtSize/2);
        filtSizeL = center-1;
        filtSizeR = filtSize-filtSizeL-1;
        sigmaq    = sigma(k)^2;
        
        for i = -filtSizeL:filtSizeR
            for j = -filtSizeL:filtSizeR 
                
                if ( sqrt(i^2+j^2)>filtSize/2 )
                    E = 0;
                else
                    x = i*cos(theta) - j*sin(theta);
                    y = i*sin(theta) + j*cos(theta);
                    E = exp(-(x^2+G^2*y^2)/(2*sigmaq))*cos(2*pi*x/lambda(k));
                end
                f(j+center,i+center) = E;
            end
        end
       
        f = f - mean(mean(f));
        f = f ./ sqrt(sum(sum(f.^2)));
        p = numSimpleFilters*(k-1) + r;
        filters(1:filtSize^2,p)=reshape(f,filtSize^2,1);
        fSiz(p)=filtSize;
        
    end
end
