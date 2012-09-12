function [fSiz,gfilters,cfilters,c1OL,numOrients] = init_color_gabor(rot, RF_siz, Div,numChannel,numPhases)


fSiz_temp = repmat(RF_siz, length(rot)*numChannel,1);
fSiz = fSiz_temp(:);
rr = unique(RF_siz);


gfilters = cell(1,length(rr));% grayscale Gabor filter bank
cfilters = cell(1,length(rr)); % full color filter banks

for i =1:length(rr)
    [gf,cf]   = get_color_filters_gabor(rr(i), rot, Div(i),numChannel,numPhases);
    cfilters{i} = cf;
    gfilters{i} = gf;
end

c1OL = 2;
numOrients = length(rot);


return




