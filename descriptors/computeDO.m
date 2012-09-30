function [ds,dc] = computeDO(s,filters,numChannel,numOrient,numPhase);


% DO simple cells
ds = zeros(size(s));
for pp = 1:numPhase
    for jj = 1:numChannel  
        for ii = 1:numOrient     
            ds(:,:,jj,ii,pp) = conv2padded(s(:,:,jj,ii,pp),filters{pp}(:,:,ii));
        end
    end
end
ds(ds<0) = 0;%rectify



% DO complex cells
tmpdc = zeros(size(s,1),size(s,2),numChannel,numOrient);
for ii = 1:numPhase
    tmpdc = tmpdc + ds(:,:,:,:,ii)/numPhase;
end

dc = zeros(size(s,1),size(s,2),numChannel/2,numOrient);
for jj = 1:numChannel/2
    dc(:,:,jj,:) = sqrt(tmpdc(:,:,jj,:).^2 + tmpdc(:,:,jj+numChannel/2,:).^2);
end


return
