function o = padimage(i,amnt,method)
%function o = padimage(i,amnt,method)
%
%padarray which operates on only the first 2 dimensions of a 3 dimensional
%image. (of arbitrary number of layers);
%
%amnt is a scalar value indicating how many pixels to buffer each side
%with.
%
%String values for pad method
%        'circular'    Pads with circular repetion of elements.
%        'replicate'   Repeats border elements of A.
%        'symmetric'   Pads array with mirror reflections of itself. 
%
%method may also be a constant value, like 0.0
if(nargin < 3)
   method = 'replicate';
end
o = zeros(size(i,1) + 2 * amnt, size(i,2) + 2* amnt, size(i,3));
for n = 1:size(i,3)
  o(:,:,n) = padarray(i(:,:,n),[amnt,amnt],method,'both');
end
