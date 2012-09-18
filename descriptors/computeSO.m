function s = computeSO(im,filter,numChannel,numOrient,numPhase)

[h_i,w_i,dim] = size(im);

s = zeros(h_i,w_i,numChannel,numOrient,numPhase);

for pp = 1:numPhase
    for jj = 1:numChannel
        for ii = 1:numOrient
            for kk=1:dim
                tmp = conv2padded(im(:,:,kk), squeeze(filter{pp}(:,:,kk,jj,ii)));                  
                s(:,:,jj,ii,pp) = s(:,:,jj,ii,pp) + tmp;%e.g. +R-center,-G-surround...
            end
        end
    end
end

% half-wave rectification to maintain positive ring rates
s(s<0) = 0;

return

