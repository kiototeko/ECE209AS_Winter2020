function pp =  Pcorr(x, y)


if length(x) > length(y)
    x = x(1:length(y));
elseif length(y) > length(x)
    y = y(1:length(x));
end

pp = corrcoef(x,y);

