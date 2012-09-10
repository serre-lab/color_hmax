function D = WindowedSoPatchDistance(Im,Patch)

%
%computes the euclidean distance between Patch and all crops of Im of
%similar size.
%
% sum_over_p(W(p)-I(p))^2 is factored as
% sum_over_p(W(p)^2) + sum_over_p(I(p)^2) - 2*(W(p)*I(p));
%
% Im and Patch must have the same number of channels
%
dIm = size(Im,3);
dPatch = size(Im,3);
if(dIm ~= dPatch)
  fprintf('The patch and image must be of the same number of layers');
end

d =  size(Patch);
Psqr = sum(sum(sum(sum(sum(Patch.^2)))));
Imsq = Im.^2;

% check the number of phases
if  d5 ~= 1
    Imsq = sum(sum(sum(Imsq,5),4),3);
else
    Imsq = sum(sum(Imsq,4),3);
end

sum_support = [ceil(d(2)/2)-1,ceil(s(1)/2)-1,floor(d(2)/2),floor(d(1)/2)];
Imsq = sumfilter(Imsq,sum_support);
PI = zeros(size(Imsq));

for i = 1:dIm
    for j=1:d(4)
        
        if d(5) ~= 1
            for k=1:d(5)
                PI = PI + conv2(Im(:,:,i,j,k),Patch(:,:,i,j,k), 'same');
            end
        else
            PI = PI + conv2(Im(:,:,i,j),Patch(:,:,i,j), 'same');
        end
        
    end
end


D = Imsq - 2 * PI + Psqr + 10^-10;


return
