function ds = computeDOS1hmax(s,filters,numChannel,numOrient)

% compute DOS1 units
ds = zeros(size(s));

for jj = 1:numChannel  
    for ii = 1:numOrient     
        ds(:,:,jj,ii) = conv2padded(s(:,:,jj,ii),filters(:,:,ii));
    end
end

% half-wave rectification to maintain positive ring rates
ds(ds<0) = 0;


return

