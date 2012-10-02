function s = SODescriptor(img_path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Color region encoding by Single-Opponent(SO) descriptors
% based on Gabor filters
% By Jun Zhang, 09/05/2012
% Email: zhangjun1126@gmail.com
% Example: SODescriptor('blue-sky.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% ------------------------------------------------------------------------
%                              Parameters
% Filter size and normalization parameters may change according to different
% image resolution.
%--------------------------------------------------------------------------
% Gabor filters  (modified from Serre et al. PAMI07)
orients = [90 0]; %orientations
numOrient = length(orients);
div = [4:-.05:3.2];
Div = div(3);
RF_siz = 11; % filter size
phase = 0;
numPhase = length(phase); % numbers of phases
numChannel = 8; %numbers of opponent color channels
% C(cyan) = G+B, Y(yellow) = R+G 
% numChannel=8, R+/G-,G+/R-,R+/C-,C+/R-,Y+/B-/B+/Y-,Wh,Bl; 
% numChannel=6, then close the Wh-Bl channel.


% normalization params
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
[~,cfilters] = get_filter_gabor(RF_siz,orients,Div,numChannel,phase);


%% ------------------------------------------------------------------------
%                           Single Opponenency
% -------------------------------------------------------------------------
% Single-opponent simple cell (SOS1)
s = computeSO(imscr,cfilters,numChannel,numOrient,numPhase);

% Divisive normalization over opponent color channels
s = divNorm_so(s,k,sigma,numChannel);




%% ------------------------------------------------------------------------
%                            visulization
% -------------------------------------------------------------------------
% visulize SOS1 response    
channelName = {'R^+-G^-','R^+-C^-','Y^+-B^-','Wh','G^+-R^-','C^+-R^-','B^+-Y^-','Bl'};
figure;
pp = 1;
for jj = 1:numChannel
    subplot(2,numChannel/2,jj); 
    %average over all orientation for visulization
    imagesc(mean(s(:,:,jj,:,pp),4)); title(channelName{jj});
    axis image; axis off;
end


return
