function mC2 = extractC2Doforcell(gfilters,cfilters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches,cImages,numPatchSizes,numChannel,numPhases,numOrients)
%
%this function is a wrapper of C2. For each image in the cell cImages,
%it extracts all the values of the C2 layer
%for all the prototypes in the cell cPatches.
%The result mC2 is a matrix of size total_number_of_patches \times number_of_images where
%total_number_of_patches is the sum over i = 1:numPatchSizes of length(cPatches{i})
%and number_of_images is length(cImages)
%The C1 parameters used are given as the variables filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL
%for more detail regarding these parameters see the matlab Hmax implmentation of Thomas Serre


numPatchSizes = min(numPatchSizes,length(cPatches));
%all the patches are being flipped. This is becuase in matlab conv2 is much faster than filter2
for i = 1:numPatchSizes,
    [siz,numpatch] = size(cPatches{i});
    siz = sqrt(siz/(numChannel/2*numOrients));
    for j = 1:numpatch,
        tmp = reshape(cPatches{i}(:,j),[siz,siz,numChannel/2,numOrients]);
        tmp = tmp(end:-1:1,end:-1:1,:,:);
        cPatches{i}(:,j) = tmp(:);
    end
end

mC2 = [];
nImages = length(cImages);

for i = 1:nImages
    fprintf(1,'%d:',i);
    stim = cImages{i};
    if max(stim(:))>1
        stim = double(stim)./255;
    end
    stim = 2*stim -1;
    
    c1  = [];
    ic2 = [];
    
    for j = 1:numPatchSizes, %for every unique patch size
        
        if isempty(c1),  %compute C2DO
            [tmpC2,~,tmpC1] = C2Do(stim, gfilters,cfilters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches{j},numChannel,numPhases);
        else
            [tmpC2] = C2Do(stim, gfilters,cfilters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches{j},c1,numChannel,numPhases);
        end
        ic2 = [ic2;tmpC2];
    end
    
    mC2 = [mC2, ic2];
end

fprintf('\n');


return

%

