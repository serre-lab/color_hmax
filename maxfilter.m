function I = maxfilter(I,radius)
%function I = maxfilter(I,radius)
%
%Performs morphological dilation on a multilayer image.
%
%I is the input image
%radius is the additional radius of the window, i.e., 5 means 11 x 11
%if a four value vector is specified for radius, then any rectangular support may be used for max.
%in the order left top right bottom.
switch length(radius)
case 1,
  I = padimage(I,radius);
  [n,m,thirdd] = size(I);
  B = I;
  for i = radius+1:m-radius,
    B(:,i,:) = max(I(:,i-radius:i+radius,:),[],2);
  end
  for i = radius+1:n-radius,
    I(i,:,:) = max(B(i-radius:i+radius,:,:),[],1);
  end
  I = unpadimage(I,radius);
case 4,
  [n,m,thirdd] = size(I);
  B = I;
  for i=1:radius(1)
    B(:,i,:) = max(I(:,max(1,i-radius(1)):min(end,i+radius(3)),:),[],2);
  end
  for i = radius(1)+1:m-radius(3),
    B(:,i,:) = max(I(:,i-radius(1):i+radius(3),:),[],2);
  end
  for i=m-radius(3)+1:m
    B(:,i,:) = max(I(:,i-radius(1):min(end,i+radius(3)),:),[],2);
  end
  for i = 1:radius(2),
    I(i,:,:) = max(B(max(1,i-radius(2)):i+radius(4),:,:),[],1);
  end
  for i = radius(2)+1:n-radius(4),
    I(i,:,:) = max(B(max(1,i-radius(2)):min(end,i+radius(4)),:,:),[],1);
  end
  for i = n-radius(4)+1:n,
    I(i,:,:) = max(B(i-radius(2):min(end,i+radius(4)),:,:),[],1);
  end
otherwise,
  error('maxfilter: poorly defined radius\n');
end
