function cPatches = extractRandC1DoPatches(cItrainingOnly, numPatchSizes, numPatchesPerSize, patchSizes, numChannel,numPhases)
%extracts random prototypes as part of the training of the C2 classification
%system.
%Note: we extract only from BAND 2. Extracting from all bands might help
%cPatches the returned prototypes
%cItrainingOnly the training images
%numPatchesPerSize is the number of sizes in which the prototypes come
%numPatchesPerSize is the number of prototypes extracted for each size
%patchSizes is the vector of the patche sizes
%modifired from Thomas Serre's Matlab code for standard Hmax

if nargin<2
    numPatchSizes = 4;
    numPatchesPerSize = 250;
    patchSizes = 4:4:16;
    numChannel = 8;
    numPhases = 2;
end


nImages = length(cItrainingOnly);

%----Settings for Training the random patches--------%
rot = [0 90];
c1ScaleSS = [1 3];
RF_siz    = [11 13];
c1SpaceSS = 10;
div = 4:-.05:3.2;
Div       = div(3:4);
%--- END Settings for Training the random patches--------%

fprintf(1,'Initializing color gabor filters -- full set...');
%creates the gabor filters use to extract the S1 layer
[fSiz,gfilters,cfilters,c1OL,numOrients] = init_color_gabor(rot, RF_siz, Div,numChannel,numPhases);
fprintf(1,'done\n');


cPatches = cell(numPatchSizes,1);
bsize = [0 0];
pind = zeros(numPatchSizes,1);

for j = 1:numPatchSizes
    cPatches{j} = zeros(patchSizes(j)^2*numOrients*numChannel/2,numPatchesPerSize);
end

%% Generating dictionary
for i = 1:numPatchesPerSize
    ii = floor(rand*nImages) + 1;
    stim = cItrainingOnly{ii};  
    if max(stim(:))>1
        stim = double(stim)./255;
    end
    stim = 2*stim - 1;
    
    c1source = C1Do(stim,gfilters,cfilters, fSiz, c1SpaceSS, c1ScaleSS, c1OL,numChannel,numPhases);
    b = c1source{1};
    bsize(1) = size(b,1);
    bsize(2) = size(b,2);
    for j = 1:numPatchSizes,
        xy = floor(rand(1,2).*(bsize-patchSizes(j)))+1;
        tmp = b(xy(1):xy(1)+patchSizes(j)-1,xy(2):xy(2)+patchSizes(j)-1,:,:);
        pind(j) = pind(j) + 1; % counting how many patches per size
        cPatches{j}(:,pind(j)) = tmp(:);
    end
    
end

fprintf('\n');


return
