function [c1,s1] = C1(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,INCLUDEBORDERS)
%function [c1,s1] = C1(stim, filters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,INCLUDEBORDERS)
%
%  A matlab implementation of the C1 code originally by Max Riesenhuber
%  and Thomas Serre.
%  Adapted by Stanley Bileschi
%
%  Returns the C1 and the S1 units' activation given the
%  input image, stim.
%  filters, fSiz, c1ScaleSS, c1ScaleSS, c1OL, INCLUDEBORDERS are the
%  parameters of the C1 system
%
%  stim   - the input image must be grayscale (single channel) and
%   type ''double''
%
%%% For S1 unit computation %%%
%
% filters -  Matrix of Gabor filters of size max_fSiz x num_filters,
% where max_fSiz is the length of the largest filter and num_filters the
% total number of filters. Column j of filters matrix contains a n_jxn_j
% filter (reshaped as a column vector and padded with zeros).
%
% fSiz - Vector of size num_filters containing the various filter
% sizes. fSiz(j) = n_j if filters j is n_j x n_j (see variable filters
% above).
%
%%% For C1 unit computation %%%
%
% c1ScaleSS  - Vector defining the scale bands, i.e. a group of filter
% sizes over which a local max is taken to get the C1 unit responses,
% e.g. c1ScaleSS = [1 k num_filters+1] means 2 scale bands, the first
% one contains filters(:,1:k-1) and the second one contains
% filters(:,k:num_filters). If N pooling bands, c1ScaleSS should be of
% length N+1.
%
% c1SpaceSS - Vector defining the spatial pooling range for each scale
% band, i.e. c1SpaceSS(i) = m_i means that each C1 unit response in band
% i is obtained by taking a max over a local neighborhood of m_ixm_i S1
% units. If N bands then c1SpaceSS should be of size N.
%
% c1OL - Scalar value defining the overlap between C1 units. In scale
% band i, the C1 unit responses are computed every c1Space(i)/c1OL.
%
% INCLUDEBORDERS - the type of treatment for the image borders.

USECONV2 = 1; %should be faster if 1

USE_NORMXCORR_INSTEAD = 0;
if(nargin < 7)
    INCLUDEBORDERS = 0;
end
numScaleBands=length(c1ScaleSS)-1;  % convention: last element in c1ScaleSS is max index + 1
numScales=c1ScaleSS(end)-1;
%   last index in scaleSS contains scale index where next band would start, i.e., 1 after highest scale!!
numSimpleFilters=floor(length(fSiz)/numScales);
ScalesInThisBand = cell(1,numScaleBands);
for iBand = 1:numScaleBands
    ScalesInThisBand{iBand} = c1ScaleSS(iBand):(c1ScaleSS(iBand+1) -1);
end


% Rebuild all filters (of all sizes)
%%%%%%%%
nFilts = length(fSiz);
sqfilter = cell(1,nFilts);
for i = 1:nFilts
    sqfilter{i} = reshape(filters(1:(fSiz(i)^2),i),fSiz(i),fSiz(i));
    if USECONV2
        sqfilter{i} = sqfilter{i}(end:-1:1,end:-1:1); %flip in order to use conv2 instead of imfilter
    end
end

% Calculate all filter responses (s1)
%%%%%%%%
sqim = stim.^2;
iUFilterIndex = 0;
% precalculate the normalizations for the usable filter sizes
uFiltSizes = unique(fSiz);
for i = 1:length(uFiltSizes)
    s1Norm{uFiltSizes(i)} = (sumfilter(sqim,(uFiltSizes(i)-1)/2)).^0.5;
    %avoid divide by zero
    s1Norm{uFiltSizes(i)} = s1Norm{uFiltSizes(i)} + ~s1Norm{uFiltSizes(i)};
end

for iBand = 1:numScaleBands
    for iScale = 1:length(ScalesInThisBand{iBand})
        for iFilt = 1:numSimpleFilters
            iUFilterIndex = iUFilterIndex+1;
            if ~USECONV2
                s1{iBand}{iScale}{iFilt} = abs(imfilter(stim,sqfilter{iUFilterIndex},'symmetric','same','corr'));
                
                if(~INCLUDEBORDERS)
                    s1{iBand}{iScale}{iFilt} = removeborders(s1{iBand}{iScale}{iFilt},fSiz(iUFilterIndex));
                end
                s1{iBand}{iScale}{iFilt} = im2double(s1{iBand}{iScale}{iFilt}) ./ s1Norm{fSiz(iUFilterIndex)};
            else %not 100% compatible but 20% faster at least
                s1{iBand}{iScale}{iFilt} = abs(conv2(stim,sqfilter{iUFilterIndex},'same'));
                if(~INCLUDEBORDERS)
                    s1{iBand}{iScale}{iFilt} = removeborders(s1{iBand}{iScale}{iFilt},fSiz(iUFilterIndex));
                end
                s1{iBand}{iScale}{iFilt} = im2double(s1{iBand}{iScale}{iFilt}) ./ s1Norm{fSiz(iUFilterIndex)};
            end
        end
        
    end
end



% Calculate local pooling (c1)
%%%%%%%%

%   (1) pool over scales within band
c1 = cell(1,numScaleBands);
for iBand = 1:numScaleBands
    for iFilt = 1:numSimpleFilters
        c1{iBand}(:,:,iFilt) = zeros(size(s1{iBand}{1}{iFilt}));
        for iScale = 1:length(ScalesInThisBand{iBand});
            c1{iBand}(:,:,iFilt) = max(c1{iBand}(:,:,iFilt),s1{iBand}{iScale}{iFilt});
        end
    end
end

%   (2) pool over local neighborhood
for iBand = 1:numScaleBands
    poolRange = (c1SpaceSS(iBand));
    for iFilt = 1:numSimpleFilters
        c1{iBand}(:,:,iFilt) = maxfilter(c1{iBand}(:,:,iFilt),[0 0 poolRange-1 poolRange-1]);
    end
end


%   (3) subsample
for iBand = 1:numScaleBands
    sSS=ceil(c1SpaceSS(iBand)/c1OL);
    clear T;

    for iFilt = 1:numSimpleFilters
        T(:,:,iFilt) = c1{iBand}(1:sSS:end,1:sSS:end,iFilt);
    end
    c1{iBand} = T;
end


function sout = removeborders(sin,siz)
sin = unpadimage(sin, [(siz+1)/2,(siz+1)/2,(siz-1)/2,(siz-1)/2]);
sin = padarray(sin, [(siz+1)/2,(siz+1)/2],0,'pre');
sout = padarray(sin, [(siz-1)/2,(siz-1)/2],0,'post');


