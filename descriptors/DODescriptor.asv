function [ds,dc] = DODescriptor(img_path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Color boundary/shape encoding by Double-Opponent(DO) descriptors
% based on Gabor filters
% By Jun Zhang, 09/05/2012
% Email: zhangjun1126@gmail.com
% Example: DODescriptor('blue-sky.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% ------------------------------------------------------------------------
%                              Parameters
% Filter size and normalization parameters may change according to different
% image resolution.
%--------------------------------------------------------------------------
% Gabor filters (modified from Serre et al. PAMI07)
orients = [90 -45 0 45]; %orientations
numOrient = length(orients);
div = [4:-.05:3.2];
Div = div(3);
RF_siz = 11; % filter size
phase = [0,90];
numPhase =length(phase); % numbers of phases
numChannel = 8; %numbers of opponent color channels
% C(cyan) = G+B, Y(yellow) = R+G 
% numChannel=8, R+/G-,G+/R-,R+/C-,C+/R-,Y+/B-/B+/Y-,Wh,Bl;
% numChannel=6, then close the Wh-Bl channel.


% Normalization params
k = 1; % scaling factor
sigma = 0.225; %semi-contrast constant



%% ------------------------------------------------------------------------
%                      load and pre-processing images
%--------------------------------------------------------------------------
im = imread(img_path);
% im = imresize(im,0.8);%reduce image size if needed.
if max(im(:))>1
    imscr = double(im)/255;
else
    imscr = im;
end
imscr = imscr * 2 -1;



%%-------------------------------------------------------------------------
%                          Gradient computation
% Here, we take Gabor filters as an example because it is biologically 
% plausible. Any gradient operators could be used, such as Gaussian 
% derivatives
% -------------------------------------------------------------------------
[gfilters,cfilters] = get_filter_gabor(RF_siz,orients,Div,numChannel,phase); 



%% ------------------------------------------------------------------------
%                           Single Opponenency
% -------------------------------------------------------------------------
s = computeSO(imscr,cfilters,numChannel,numOrient,numPhase);

% Divisive normalization over orientations
% Note: this step is different from the one used for SO descriptors
s = divNorm_do(s,k,sigma,numOrient);




%% ------------------------------------------------------------------------
%                            Double Oppnency
% -------------------------------------------------------------------------
% ds: Double-Opponent simple cell(DOS1)
% dc: Double-Opponnet complex cell(DOC1)
% GrayFilter is used at the DO stage is the same as the one used at the SO
% stage but in the general case any filter with excitatory and inhibitory 
% components could be used.
[ds,dc] = computeDO(s,gfilters,numChannel,numOrient,numPhase);




%% ------------------------------------------------------------------------
%                            visulization
% -------------------------------------------------------------------------
% visulize the DOS1 response
channelName1 = {'R^+-G^-','R^+-C^-','Y^+-B^-','Wh','G^+-R^-','C^+-R^-','B^+-Y^-','Bl'}; 
figure;
pp = 1; % phase: 0 deg
for jj = 1:numChannel
    subplot(2,numChannel/2,jj); 
    imagesc(max(ds(:,:,jj,:,pp),[],4)); %max over all orientation
    axis image; axis off; title(channelName1{jj});
end



% visulize the DOC1 response
channelName2 = {'R-G','R-C','Y-B','Wh-Bl'};
figure;
pp = 1; 
for jj = 1:numChannel/2
    subplot(1,numChannel/2,jj); 
    imagesc(max(dc(:,:,jj,:,pp),[],4)); %max over all orientation
     axis image; axis off; title(channelName2{jj});
end


% visulize the DOedge response
% max over orientations
figure;imagesc(max(max(dc,[],4),[],3));axis image;

return
