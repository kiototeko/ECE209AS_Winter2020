BL = 12000;          % Arbitrarily set
fm=7000;
Fs = 96000;
Ac=1;
t_span = 0.5;
t = 0:1/Fs:t_span;
m=sin(2*pi*fm*t);
zeta = 0.707;       % Set in Specs
k1 = mean(abs((Ac*m).^2))
alpha = 2*zeta*2*BL/(zeta+1/4/zeta)/Fs/k1
beta = ((2*BL/(zeta+1/4/zeta)/Fs))^2/k1
ratio=alpha/beta
Hnum = [ k1*(beta+alpha)  -k1*alpha];
Hden = [1 -(2-k1*(alpha+beta)) (1-k1*alpha)];
LF = filter(Hnum, Hden, [zeros(1,100) ones(1,2000)]);