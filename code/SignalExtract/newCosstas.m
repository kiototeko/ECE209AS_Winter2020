clear all;
order=32;

Fs = 96000; 
f = 0.1:0.001:0.901;
a = ones(length(f));
b = remez(order, f, a, 'hilbert');
[gd,f] = grpdelay(b,1,512,'whole',Fs);
groupdelay=gd(10);

fc = 24000;
alpha = 0.666;%0.2778;
beta = 0.111;%0.0193;



%{
basedir = '../python/samples_';
files = {'1','10','20','30','40','50','60'};
dires = strcat(basedir, files);

for dds = 1:length(dires)
projectdir = dires{dds};
%}

projectdir = '../python/samples';
dinfo = dir(fullfile(projectdir));
dinfo([dinfo.isdir]) = [];     %get rid of all directories including . and ..
nfiles = length(dinfo);

for j = 1 : nfiles
    
filename = fullfile(projectdir, dinfo(j).name);
[filepath,name,ext] = fileparts(filename) ;

%{
if(length(name) >= 4 && str2num(name(3:4)) >= 50)
    continue
end
%}

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


len = length(input);
hilbert_output = filter(b, 1, input); %Initialization
analytic = input(1:len-groupdelay) + j*hilbert_output(groupdelay+1:len);
% similar to analytic = hilbert(input);

out = [];
phi = [];
phi(1) = 0;
temp_out1=0;
temp_pre_out1=0;
temp_out2=0;
temp_out3=0;%Simulation

for I=1:len-groupdelay    
    phi(I)= temp_out3;     
    phase(I) = exp(-i*phi(I));    
    c1(I) = real(analytic(I)*phase(I));    
    c2(I) = imag(analytic(I)*phase(I));    
    out(I)= sign(c1(I));    
    q(I) = sign(c1(I))*c2(I);    
    temp_out1=temp_pre_out1+q(I)*beta;    
    temp_out2=alpha*q(I)+ temp_out1;    
    temp_out3=2*pi*fc/Fs+phi(I)+temp_out2;    
    temp_pre_out1=temp_out1;
end
Hd = designfilt('lowpassfir','FilterOrder',50,'CutoffFrequency',7000, ...
       'SampleRate',Fs);

inst= c1;

sizes = [];

k = 1602;
chuks = sample_obtain(k,1,0.4,inst);

if ~isempty(chuks)
cc = mean(chuks);

save(strcat(filepath, '/', name), 'cc', '-v7');
end
end
%end