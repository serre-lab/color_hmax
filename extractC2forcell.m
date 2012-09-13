function mC2 = extractC2forcell(filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches,cImages,numPatchSizes,numSimpleFilters);
%
%this function is a wrapper of C2. For each image in the cell cImages,
%it extracts all the values of the C2 layer
%for all the prototypes in the cell cPatches.
%The result mC2 is a matrix of size total_number_of_patches \times number_of_images where
%total_number_of_patches is the sum over i = 1:numPatchSizes of length(cPatches{i})
%and number_of_images is length(cImages)
%The C1 parameters used are given as the variables filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL
%for more detail regarding these parameters see the help entry for C1
%
%See also C1



numPatchSizes = min(numPatchSizes,length(cPatches));
%all the patches are being flipped. This is becuase in matlab conv2 is much faster than filter2
for i = 1:numPatchSizes,
    [siz,numpatch] = size(cPatches{i});
    siz = sqrt(siz/numSimpleFilters);
    for j = 1:numpatch,
        tmp = reshape(cPatches{i}(:,j),[siz,siz,numSimpleFilters]);
        tmp = tmp(end:-1:1,end:-1:1,:);
        cPatches{i}(:,j) = tmp(:);
    end
end



mC2 = [];
for i = 1:length(cImages), %for every input image
    fprintf(1,'%d:',i);
    stim = cImages{i};
    [~,~,unused] = size(stim);
    if unused ~= 1;
        stim = rgb2gray(stim);
    end
    
    c1  = [];
    iC2 = [];
    for j = 1:numPatchSizes, %for every unique patch size
        fprintf(1,'.');
        if isempty(c1),  %compute C2
            [tmpC2,~,c1] = C2(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches{j});
        else
            [tmpC2] = C2(stim,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,cPatches{j},c1);
        end
        iC2 = [iC2;tmpC2];
    end
    
    mC2 = [mC2, iC2];
    
    
end

fprintf('\n');
