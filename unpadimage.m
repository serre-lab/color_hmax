function o = unpadimage(i,amnt)
%function o = unpadimage(i,amnt)
%
%un does padimage
%if length(amnt == 1), unpad equal on each side
%if length(amnt == 2), first amnt is left right, second up down
%if length(amnt == 4), then [left top right bottom];

switch(length(amnt))
case 1
  sx = size(i,2) - 2 * amnt;
  sy = size(i,1) - 2 * amnt;
  l = amnt + 1;
  r = size(i,2) - amnt;
  t = amnt + 1;
  b = size(i,1) - amnt;
case 2
  sx = size(i,2) - 2 * amnt(1);
  sy = size(i,1) - 2 * amnt(2);
  l = amnt(1) + 1;
  r = size(i,2) - amnt(1);
  t = amnt(2) + 1;
  b = size(i,1) - amnt(2);
case 4
  sx = size(i,2) - (amnt(1) + amnt(3));
  sy = size(i,1) - (amnt(2) + amnt(4));
  l = amnt(1) + 1;
  r = size(i,2) - amnt(3);
  t = amnt(2) + 1;
  b = size(i,1) - amnt(4);
otherwise
  error('illegal unpad amount\n');
end
if(any([sx,sy] < 1))
    fprintf('unpadimage newsize < 0, returning []\n');
    o = [];
    return;
end
% if(any([sx,sy] < 1))
%     o = i(b:t,r:l,:);
% else
    o = i(t:b,l:r,:);
% end
