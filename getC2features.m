% This example illustrates how to get C2 features on dataset.
% C2res_gray & C2res_do: shape coding
% C2res_so: color coding

% read images
% datapath: directory of dataset
% numTrain: numbers of training examples
% numTest: numbers of testing examples
% trn: the training labels of all classes
% tst: the testing labels of all classes
cI = loadAllImages(datapath,numTrain,numTest,trn,tst);


% get C2 features for all images(cI)
C2res_gray = demoRelease(cI);   %grayscale Hmax
C2res_so   = demoSoRelease(cI); %SOHmax
C2res_do   = demoDoRelease(cI); %DOHmax


 