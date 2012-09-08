function s = divNorm_so(s,k,sigma,numChannel);

E = squeeze(sum(s.^2,3))./numChannel;

for jj = 1:numChannel
    s(:,:,jj,:,:) = sqrt(k.* squeeze(s(:,:,jj,:,:)).^2 ./ (sigma.^2 + E));
end


return