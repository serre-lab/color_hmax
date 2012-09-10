function I3 = sumfilter(I,radius);
%function I3 = sumfilter(I,radius);
%
%I is the input image
%radius is the additional radius of the window, i.e., 5 means 11 x 11
%if a four value vector is specified for radius, then any rectangular support may be used for max.
%in the order left top right bottom.

if (size(I,3) > 1)
    error('Only single-channel images are allowed');
end

switch length(radius)
  case 4,
    I2 = conv2(ones(1,radius(2)+radius(4)+1), ones(radius(1)+radius(3)+1,1), I);
    I3 = I2((radius(4)+1:radius(4)+size(I,1)), (radius(3)+1:radius(3)+size(I,2)));
  case 1,
    mask = ones(2*radius+1,1);
    I2 = conv2(mask, mask, I);
    I3 = I2((radius+1:radius+size(I,1)), (radius+1:radius+size(I,2)));  
end
