function [c1,dc] = C1Do(stim, gfilters, cfilters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,numChannel,numPhases)
% For more information about S1/C1 unit, refer to Thomas Serre's Matlab
% code for standard Hmax

% normalization params
k = 1; % scaling factor
sigma = 0.225; %semi-contrast constant


if(nargin < 10)
    INCLUDEBORDERS = 0;
end
numScaleBands=length(c1ScaleSS)-1; 
numScales=c1ScaleSS(end)-1;
%   last index in scaleSS contains scale index where next band would start, i.e., 1 after highest scale!!
numSimpleFilters = floor(length(fSiz)/numScales/numChannel);

ScalesInThisBand = cell(1,numScaleBands);
for iBand = 1:numScaleBands
    ScalesInThisBand{iBand} = c1ScaleSS(iBand):(c1ScaleSS(iBand+1) -1);
end




%% --------------------------------------------------------------
%                Calculate all filter responses (s1)
% -------------------------------------------------------------------------
s1 = {};
for iBand = 1:numScaleBands
    for iScale = 1:length(ScalesInThisBand{iBand})
        sc = (iBand-1)*length(ScalesInThisBand{iBand}) + iScale;
        
         % -----------Compute Single-Opponency----------%
        for iPhase = 1:numPhases
             iUFilterIndex = 0;
             
             s1{iBand}{iScale}(:,:,:,:,iPhase) = computeSOhmax(stim,cfilters{sc}{iPhase},numChannel,numSimpleFilters);%SOS1 unit
          
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
      
        % --------Divisive normalization over orientations---------%
        % Note: this is different from normalization used for computing SO
        % descriptors
        s1{iBand}{iScale} = divNorm_do(s1{iBand}{iScale},k,sigma,numSimpleFilters);
        
        
        
        % -----------Compute Double-Opponency----------------%
        % ds: Double-Opponent simple cell(DOS1)
        % dc: Double-Opponnet complex cell(DOC1)
        % gfilters is used at the DO stage is the same as the one used at the SO
        % stage but in the general case any filter with excitatory and inhibitory 
        % components could be used.
        
        tmpdc = zeros(size(stim,1),size(stim,2),numChannel,numSimpleFilters);
        for iPhase = 1:numPhases
            % DOS1 unit
            ds = computeDOS1hmax(s1{iBand}{iScale}(:,:,:,:,iPhase),gfilters{sc}{1},numChannel,numSimpleFilters);
            % DOC1 unit
            tmpdc =  tmpdc + ds ./ numPhases;
        end
        
        % yield invariance to figure-ground reversal
        for jj = 1:numChannel/2
            dc{iBand}{iScale}(:,:,jj,:) = sqrt(tmpdc(:,:,jj,:).^2 + tmpdc(:,:,jj+numChannel/2,:).^2);
        end

        
    end
end




%% ---------------------------------------------------------------
%                      Calculate local pooling (DOC1 units)
% -------------------------------------------------------------------------

%   (1) pool over scales within band
c1 = {};
for iBand = 1:numScaleBands
    for jj=1:numChannel/2
        for iFilt = 1:numSimpleFilters
            
            c1{iBand}(:,:,jj,iFilt,iPhase) = zeros(size(dc{iBand}{1}(:,:,jj,iFilt)));  
            for iScale = 1:length(ScalesInThisBand{iBand});
                c1{iBand}(:,:,jj,iFilt) = max(c1{iBand}(:,:,jj,iFilt),dc{iBand}{iScale}(:,:,jj,iFilt));
            end
        end
        
    end
end

    
    
%   (2) pool over local neighborhood
for iBand = 1:numScaleBands
    poolRange = (c1SpaceSS(iBand));
    
    for jj=1:numChannel/2
        for iFilt = 1:numSimpleFilters 
            c1{iBand}(:,:,jj,iFilt) = maxfilter(c1{iBand}(:,:,jj,iFilt),[0 0 poolRange-1 poolRange-1]);
        end
    end
    
end

% 
%   (3) subsample
for iBand = 1:numScaleBands 
    sSS=ceil(c1SpaceSS(iBand)/c1OL);
    clear T;
    
    for jj=1:numChannel/2
        for iFilt = 1:numSimpleFilters 
            T(:,:,jj,iFilt) = c1{iBand}(1:sSS:end,1:sSS:end,jj,iFilt); 
        end
    end
    c1{iBand} = T;

end


function sout = removeborders(sin,siz)
sin = unpadimage(sin, [(siz+1)/2,(siz+1)/2,(siz-1)/2,(siz-1)/2]);
sin = padarray(sin, [(siz+1)/2,(siz+1)/2],0,'pre');
sout = padarray(sin, [(siz-1)/2,(siz-1)/2],0,'post');
return
