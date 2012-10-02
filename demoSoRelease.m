function  C2res = demoSoRelease(cI)
%
% demonstrates how to use C2 Single-Opponent model features in a pattern classification framework
% on soccer team dataset (color predominant)
% cI is a cell of length 2: training and testing set
% See details to compute SO descriptors in SODescriptor.m
% You could mofify your spatial info., such as number of phases,
% orientations to adapt to your task
% If you find any bugs, please contact Jun Zhang(zhangjun1126@gmail.com)



outDir = sprintf('../results');
if ~exist(outDir,'dir')
    mkdir(outDir);
end



%% ---------------------------------------------------------------
%           load C1SO prototypes if exsits or extract your own prototypes
% -------------------------------------------------------------------------

READPATCHESFROMFILE = 0;
patchSizes = [4 8 12 16];
numPatchSizes = length(patchSizes);
numPatchesPerSize = 250;
numPhases = 1;
numChannel = 8; %numbers of opponent color channels
% C(cyan) = G+B, Y(yellow) = R+G
% numChannel=8, R+/G-,G+/R-,R+/C-,C+/R-,Y+/B-/B+/Y-,Wh,Bl;
% numChannel=6, then close the Wh-Bl channel.


if ~READPATCHESFROMFILE
    %take more time to compute
    fprintf('extracting randome SO patches');
    cPatches = extractRandC1SoPatches(cI{1}, numPatchSizes, ...
        numPatchesPerSize, patchSizes,numChannel,numPhases);
    
    save(fullfile(outDir,sprintf('dictSo_%i_patches_%i_sizes.mat', ...
        numPatchesPerSize, length(patchSizes))) ,'cPatches','-v7.3');
    
else
    fprintf('reading patches');
    cPatches = load(sprintf('dictSo_%i_patches_%i_sizes.mat', ...
        numPatchesPerSize, length(patchSizes)) ,'cPatches');
    cPatches = cPatches.cPatches;
    
end



%% ------------------------------------------------------------------------
%                            compute C2SO features
% -------------------------------------------------------------------------

%----Settings for Testing --------%
rot       = [0 90];
c1ScaleSS = 1:2:18;
RF_siz    = 7:2:39;
c1SpaceSS = 8:2:22;
div       = 4:-.05:3.2;
Div       = div;
%      %--- END Settings for Testing --------%


fprintf(1,'Initializing color gabor filters -- full set...');
%creates the gabor filters use to extract the S1 layer
[fSiz,~,cfilters,c1OL,numOrients] = init_color_gabor(rot, RF_siz, Div,numChannel,numPhases);
fprintf(1,'done\n');


% % The actual C2 features are computed below for each one of the training/testing directories
C2res = cell(1,2);
tic
for i = 1:2,
    C2res{i} = extractC2Soforcell(cfilters,fSiz,c1SpaceSS,c1ScaleSS,...
        c1OL,cPatches,cI{i},numPatchSizes,numChannel,numPhases,numOrients);
    toc
end
totaltimespectextractingC2 = toc;

% save C2SO features
save(fullfile(outDir,sprintf('c2so_%i_patches_%i_sizes.mat', ...
    numPatchesPerSize, length(patchSizes))), 'C2res','-v7.3');


return

%
