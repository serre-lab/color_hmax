
% read images
% trn: the training labels of all classes
% tst: the testing labels of all classes
cI = loadAllImages(datapath,numTrain,numTest,trn,tst);


% get C2 features for all images
C2res_gray = demoRelease(cI); %grayscale Hmax
C2res_so   = demoSoRelease(cI); %SOHmax
C2res_do   = demoDoRelease(cI); %DOHmax


