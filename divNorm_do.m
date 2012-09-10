function s = divNorm_do(s,k,sigma,numOrient);

E = squeeze(sum(s.^2,4))./numOrient;

for jj = 1:numOrient
    s(:,:,:,jj,:) = sqrt(k.* squeeze(s(:,:,:,jj,:)).^2 ./ (sigma.^2 + E));
end


return