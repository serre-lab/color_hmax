
tst3 = [];
for ii = 1:105;
    [pathstr, name, ext] = fileparts(test{ii});
    tst3 = [tst3,str2double(name)];
end