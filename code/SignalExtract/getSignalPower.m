function p = getSignalPower(projectdir, Fs)

dinfo = dir(fullfile(projectdir));
dinfo([dinfo.isdir]) = [];     %get rid of all directories including . and ..
nfiles = length(dinfo);
p = 0;

for j = 1 : nfiles
    
filename = fullfile(projectdir, dinfo(j).name);
[filepath,name,ext] = fileparts(filename) ;

if ~(ext == ".wav")
    continue;
end


[y, Fs] = audioread(filename);


%input = y(1000:length(y));
input = y;
bpFilt = designfilt('bandpassfir', 'FilterOrder', 50, ...
             'CutoffFrequency1', 18000, 'CutoffFrequency2', 30000,...
             'SampleRate', Fs);
input = filter(bpFilt, input);


p = p + bandpower(input, Fs, [0 Fs/2]);

end

p = p/nfiles;