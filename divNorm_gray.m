function g = divNorm_gray(g,k,sigma,rot);


E =  squeeze(sum(g.^2,3)) ./ length(rot);


for ii = 1:length(rot)
    g(:,:,ii,:) = sqrt(k.* squeeze(g(:,:,ii,:)).^2 ./ (sigma.^2 + E));
end


return