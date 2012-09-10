function [c1,s1] = C1So(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,numChannel,numPhases)
% For more information about S1/C1 unit, refer to Thomas Serre's Matlab
% code for standard Hmax

USECONV2 = 1; %should be faster if 1
% normalization params
k = 1; % scaling factor
sigma = 0.225; %semi-contrast constant


USE_NORMXCORR_INSTEAD = 0;
if(nargin < 10)
    INCLUDEBORDERS = 0;
end
numScaleBands=length(c1ScaleSS)-1; 
numScales=c1ScaleSS(end)-1;
%   last index in scaleSS contains scale index where next band would start, i.e., 1 after highest scale!!
numSimpleFilters = floor(length(fSiz)/numScales/numChannel);

for iBand = 1:numScaleBands
    ScalesInThisBand{iBand} = c1ScaleSS(iBand):(c1ScaleSS(iBand+1) -1);
end




%% ------------------------------------------------------------------------
%                Calculate all filter responses (s1)
% -------------------------------------------------------------------------
sqim = stim.^2;
iUFilterIndex = 0;
uFiltSizes = unique(fSiz);

for iBand = 1:numScaleBands
    for iScale = 1:length(ScalesInThisBand{iBand})
        sc = (iBand-1)*length(ScalesInThisBand{iBand}) + iScale;
        
        for iPhase = 1:numPhases
             iUFilterIndex = 0;
             
            % -----------Compute Single-Opponency--------------------------
            s1{iBand}{iScale}(:,:,:,:,iPhase) = computeSOhmax(stim,filters{sc}{iPhase},numChannel,numSimpleFilters);%double opponent simple cell
          
            if(~INCLUDEBORDERS)   
                  for jj=1:numChannel
                      for ii = 1:numSimpleFilters
                          iUFilterIndex = iUFilterIndex+1;
                          s1{iBand}{iScale}(:,:,jj,ii,iPhase) = removeborders(s1{iBand}{iScale}(:,:,jj,ii,iPhase),fSiz(iUFilterIndex+numChannel*numSimpleFilters*(sc-1)));      
                      end
                  end
            end
            s1{iBand}{iScale} = im2double(s1{iBand}{iScale});
        end
      
        % --------Divisive normalization over opponent color channels------
        s1{iBand}{iScale} = divNorm_so(s1{iBand}{iScale},k,sigma,numChannel);
        
    end
end




%% ------------------------------------------------------------------------
% Calculate local pooling (c1)
% -------------------------------------------------------------------------

%   (1) pool over scales within band

c1 = {};
for iBand = 1:numScaleBands
    for jj=1:numChannel
        for iFilt = 1:numSimpleFilters
            for iPhase = 1:numPhases
               
                c1{iBand}(:,:,jj,iFilt,iPhase) = zeros(size(s1{iBand}{1}(:,:,jj,iFilt,iPhase)));  
                for iScale = 1:length(ScalesInThisBand{iBand});
                    c1{iBand}(:,:,jj,iFilt,iPhase) = max(c1{iBand}(:,:,jj,iFilt,iPhase),s1{iBand}{iScale}(:,:,jj,iFilt,iPhase));
                end

            end
        end
    end
end

    
    
%   (2) pool over local neighborhood
for iBand = 1:numScaleBands
    poolRange = (c1SpaceSS(iBand));
    for jj=1:numChannel
        for iFilt = 1:numSimpleFilters 
            for iPhase = 1:numPhases
                c1{iBand}(:,:,jj,iFilt,iPhase) = maxfilter(c1{iBand}(:,:,jj,iFilt,iPhase),[0 0 poolRange-1 poolRange-1]);
            end
        end
    end
end

% 
%   (3) subsample
for iBand = 1:numScaleBands 
    sSS=ceil(c1SpaceSS(iBand)/c1OL);
    clear T;
    
    for jj=1:numChannel
        for iFilt = 1:numSimpleFilters 
            for iPhase = 1:numPhases
                T(:,:,jj,iFilt,iPhase) = c1{iBand}(1:sSS:end,1:sSS:end,jj,iFilt,iPhase); 
            end
        end
    end
    c1{iBand} = T;

end


function sout = removeborders(sin,siz)
sin = unpadimage(sin, [(siz+1)/2,(siz+1)/2,(siz-1)/2,(siz-1)/2]);
sin = padarray(sin, [(siz+1)/2,(siz+1)/2],0,'pre');
sout = padarray(sin, [(siz-1)/2,(siz-1)/2],0,'post');
return
