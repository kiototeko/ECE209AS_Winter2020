Fs = 96000;

projectdir = '../python/samples2';

p1 = getSignalPower(projectdir, Fs);

basedir = '../python/samples_';
files = {'1','10','20','30','40','50','60'};
dires = strcat(basedir, files);

signat_to_noise = [];

for dds = 1:length(dires)
projectdir = dires{dds};

p2 = getSignalPower(projectdir, Fs);

signat_to_noise = [signat_to_noise p1/abs(p2 - p1)];
end





