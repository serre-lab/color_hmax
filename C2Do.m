function [c2,s2,c1] = C2Do(stim, gfilters,cfilters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,s2Target,numChannel,numPhases)
% given an image extracts layers s1 c1 s2 and finally c2
% for inputs stim, filters, fSiz, c1SpaceSS,c1ScaleeSS, and c1OL
%
% briefly,
% stim is the input image.
% filters fSiz, c1SpaceSS, c1ScaleSS, c1OL are the parameters of
% the c1 process
%
% s2Target are the prototype (patches) to be used in the extraction
% of s2.  Each patch of size [n,n,d] is stored as a column in s2Target,
% which has itself a size of [n*n*d, n_patches];
%
% if available, a precomputed c1 layer can be used to save computation
% time.  The proper format is the output of C1.m
%
%  modified from a matlab Hmax implmentation of Thomas Serre


if nargin<11
    c1 = C1Do(stim, gfilters,cfilters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,numChannel,numPhases);
end

nbands = length(c1);
c1BandImage = c1;
nfilts1 = size(c1{1},3);
nfilts2 = size(c1{1},4);
n_rbf_centers = size(s2Target,2);
L = size(s2Target,1) / (nfilts1*nfilts2);
PatchSize = [L^.5,L^.5,nfilts1,nfilts2];



%%-------------------------------------------------------------------------
% Build s2do: for all prototypes in s2Target (RBF centers) for all bands
% calculate the image response
% -------------------------------------------------------------------------
s2 = cell(n_rbf_centers,1);
for iCenter = 1:n_rbf_centers
    Patch = reshape(s2Target(:,iCenter),PatchSize);
    s2{iCenter} = cell(nbands,1);
    for iBand = 1:nbands
        s2{iCenter}{iBand} = WindowedDoPatchDistance(c1BandImage{iBand},Patch);
    end
end



%%-------------------------------------------------------------------------
% Build c2do: calculate minimum distance (maximum stimulation) across position
% and scales
% -------------------------------------------------------------------------
c2 = inf(n_rbf_centers,1);
for iCenter = 1:n_rbf_centers
    for iBand = 1:nbands
        c2(iCenter) = min(c2(iCenter),min(min(s2{iCenter}{iBand})));
    end
end


return
