function [fSiz,gfilters,subfilters, cfilters,c1OL,numOrients] = init_color_gabor(rot, RF_siz, Div,numChannel,numPhases)

gfilters = {};% grayscale Gabor filter bank
subfilters = {}; %  positive(excitory)/negative(inhibitory) units of Gabor filter
cfilters = {};% full color filter banks


fSiz_temp = repmat(RF_siz, length(rot)*numChannel,1);
fSiz = fSiz_temp(:);
rr = unique(RF_siz);

for i =1:length(rr)
    [gf,f,cf]   = get_color_filters_gabor(rr(i), rot, Div(i),numChannel,numPhases);
    
    cfilterss{i} = cf;
    subfilters{i} = f;
    gfilters{i} = gf;
end

c1OL = 2;
numOrients = length(rot);


return




