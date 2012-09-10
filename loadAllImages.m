function cI = loadAllImages(datapath,numTrain,numTest,trn,tst);
%Reads all training and testing images into a cell

if nargin<3
  maximagesperdir = inf;
end

dirs = dir(datapath);
catNames = {dirs([dirs.isdir]).name};
catNames = setdiff(catNames, {'.', '..'});
[ans, inds] = sort(lower(catNames));
catNames = catNames(inds);
Nclasses = length(catNames);


cI = cell(1,2);
ntrn = 0;
ntst = 0;

for ii = 1:Nclasses
    imgDir = fullfile(datapath, catNames{ii});
    iids = dir(fullfile(imgDir,'*jpg'));
    idTrn = trn(numTrain*(ii-1)+1:numTrain*(ii-1)+numTrain);% read the images belong to ith class
    idTst = tst(numTest*(ii-1)+1:numTest*(ii-1)+numTest);% read the images belong to ith class

    for jj = 1:numTrain,
        ntrn = ntrn + 1;
        iid = iids(idTrn(jj));
        imgFile = fullfile(imgDir,iid.name);
        cI{1}{ntrn} = double(imread(imgFile)) ./ 255 ;
    end
    
    for jj = 1:numTest
        ntst = ntst + 1; 
        iid = iids(idTst(jj));
        imgFile = fullfile(imgDir,iid.name);
        cI{2}{ntst} = double(imread(imgFile)) ./ 255 ;
    end
         
end


fprintf('done.\n');
