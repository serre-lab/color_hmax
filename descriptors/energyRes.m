function [gs,gc] = energyRes(img_path);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Energy model based on Gabor filters
% gs: S1 map
% gc: energy response(C1 map)
% By Jun Zhang, 09/05/2012
% Email: zhangjun1126@gmail.com
% Example: energyRes('blue-sky.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% ------------------------------------------------------------------------
%                              Parameters
% Filter size and normalization parameters may change according to different
% image resolution.
%--------------------------------------------------------------------------
% Gabor filters  (modified from Serre et al. PAMI07)
orients = [45 0 -45 90]; %orientations
numOrient = length(orients);
div = [4:-.05:3.2];
Div = div(3);
RF_siz = 11; % filter size
phase = [0 90]; 
numPhase = length(phase);



%% ------------------------------------------------------------------------
%                      load and pre-processing images
%--------------------------------------------------------------------------
im = imread(img_path);
im = imresize(im,0.8);%reduce image size if needed.
if max(im(:))>1
    imscr = double(im)/255;
else
    imscr = im;
end
imscr = rgb2gray(imscr);
[mm,nn] = size(imscr);


%%-------------------------------------------------------------------------
%                          Gradient computation
% Here, we take Gabor filters as an example because it is biologically 
% plausible. Any gradient operators could be used, such as Gaussian 
% derivatives
% -------------------------------------------------------------------------
filters = get_filters(RF_siz,orients,Div,phase);


%% ------------------------------------------------------------------------
%                           Energy response
% -------------------------------------------------------------------------
% S1 response
gs = zeros(mm,nn,numOrient,numPhase);
for pp = 1:numPhase
    for ii = 1:numOrient
        gs(:,:,ii,pp) = abs(conv2padded(imscr, filters{pp}(:,:,ii)));
    end
end

% C1 response(energy)
gc = sqrt(sum(gs.^2,4));


%% ------------------------------------------------------------------------
%                            visulization
% -------------------------------------------------------------------------
% visulize Gabor filters
phase = {'0\circ','90\circ'};
figure;% show 4 phases at one orientation
for pp = 1:numPhase
    subplot(1,2,pp);
    imagesc(filters{pp}(:,:,1));title(phase{pp});
    axis image;axis off;colormap gray
end

% visulize S1 response    
figure;
pp = 1; 
for jj = 1:numOrient
    subplot(2,2,jj); 
    imagesc(gs(:,:,jj,pp)); 
    axis image; axis off;
    colorbar('SouthOutside');
end
% max over orientations
figure;
for pp = 1:numPhase
    subplot(1,2,pp);imagesc(max(gs(:,:,:,pp),[],3));axis image;axis off;
end

% visulize C1 response   
figure; imagesc(max(gc,[],3));axis image;axis off;colorbar;



return
