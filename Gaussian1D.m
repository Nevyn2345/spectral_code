function F = Gaussian1D(c,xdata)
F = c(4)+(c(1)*exp(-1*((((xdata(:,1)-c(2)).^2)/c(3).^2))));