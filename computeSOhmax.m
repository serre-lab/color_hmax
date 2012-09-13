function s = computeSOhmax(im,filter,numChannel,numOrient)

[h_i,w_i,dim] = size(im);

s = zeros(h_i,w_i,numChannel,numOrient);

for jj = 1:numChannel
    for ii = 1:numOrient
        
        for kk=1:dim
            tmp = conv2padded(im(:,:,kk), squeeze(filter(:,:,kk,jj,ii)));                  
            s(:,:,jj,ii) = s(:,:,jj,ii) + tmp;%e.g. +R-center,-G-surround...
        end
        
    end
end

% half-wave rectification to maintain positive ring rates
s(s<0) = 0;

return

